Return-Path: <linux-kernel-owner+w=401wt.eu-S1762987AbYBVVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987AbYBVVlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYBVVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:41:46 -0500
Received: from mx2.compro.net ([216.54.166.4]:14334 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940AbYBVVlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:41:45 -0500
X-IronPort-AV: E=Sophos;i="4.25,392,1199682000"; 
   d="scan'208";a="1746926"
Message-ID: <47BF40D7.5050301@compro.net>
Date: Fri, 22 Feb 2008 16:38:31 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: markh@compro.net
CC: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
References: <47BD9588.9080803@compro.net> <47BEFD4B.9060803@cs.wisc.edu> <47BEFF5F.9020002@cs.wisc.edu> <47BF0CE2.306@compro.net>
In-Reply-To: <47BF0CE2.306@compro.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Mike Christie wrote:
>> Mike Christie wrote:
>>> Mark Hounschell wrote:
>>>> I seem to have run into some sort of regression in the SG_IO
>>>> interface of 2.6.24.2. I have an application that up until 2.6.24
>>>> worked fine. The 2.6.23.16 kernel works fine.
>>>>
>>>> During reads I get these kernel messages. Writes and other functions
>>>> _seem_ OK. Actually basic
>>>> reads  are working. Its with large BC reads using an io_vec list that
>>>> the problem shows up.
>>>>
>>> Are you doing SG_IO to the sg device (/dev/sg*) or to the block device
>>> (/dev/sdX)?
>> If you are doing SG_IO to the sg device, then I know of one regression
>> (well not regression exactly, but I fixed a bug but the patch got
>> partially overwritten by another patch and that caused a new bug). Both
>> bugs are fixed in 2.6.25-rc2. Could you try that out if you are doing
>> SG_IO to the sg device.
>>
> 
> Yes, I'm using /dev/sg*. And yes again I'll checkout 2.6.25-rc2 ASIC.
> 
> Thanks
> Mark
> -
 
2.6.25-rc2 does fix the problem I'm having. I don't suppose there is a patch
lying around for 2.6.24.2??

Thanks
Mark

