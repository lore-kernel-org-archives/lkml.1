Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbYG3Plt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbYG3Plt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYG3Plk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:41:40 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:35031 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbYG3Plj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:41:39 -0400
X-Authority-Analysis: v=1.0 c=1 a=BYonhTRQpbAA:10 a=IhWaeWlHaAEA:10
 a=jV8d13ai_0P2_Nw8ZgEA:9 a=8y8HHg5i13rYfAtYVzYA:9 a=nqZCXiU78Dqf5DtkGpIA:7
 a=VCtWmC6FdnRalRiH9lM-BglSAGcA:4 a=Mz_smNXqyOQA:10
Message-ID: <48908C27.2060308@splhi.com>
Date: Wed, 30 Jul 2008 08:43:35 -0700
From: Tim Wright <timw@splhi.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Fix miscalculation of sg_io timeout in	CDROM_SEND_PACKET
 handler.
References: <488D17DE.5000801@splhi.com> <1217431134.3335.15.camel@localhost.localdomain>
In-Reply-To: <1217431134.3335.15.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-07-27 at 17:50 -0700, Tim Wright wrote:
>   
>> @@ -629,7 +629,7 @@ int scsi_cmd_ioctl(struct file *file, st
>>                         hdr.sbp = cgc.sense;
>>                         if (hdr.sbp)
>>                                 hdr.mx_sb_len = sizeof(struct 
>> request_sense);
>> -                       hdr.timeout = cgc.timeout;
>> +                       hdr.timeout = jiffies_to_msecs(cgc.timeout);
>>                         hdr.cmdp = ((struct cdrom_generic_command 
>> __user*) arg)->cmd;
>>                         hdr.cmd_len = sizeof(cgc.cmd);
>>     
>
> I'm afraid this patch is completely whitespace damaged:  the tabs have
> all become spaces and the mailer has broken some of the lines.
>
> Since it's a one liner, I can make the fix directly, but if you look at
>
> Documentation/SubmittingPatches
>
> It has some good advice about how to fix your email tool to prevent this
> from happening in future.
>
> James
>
>
>   
Ugh, mea culpa! Thanks James. I haven't submitted anything in a while, 
and was using Thunderbird. I will
go off and figure out how to make it leave the contents alone, or I'll 
use a less "clever" client in future.
Many thanks for the response and the gentle coaching :-)

Regards,

Tim

