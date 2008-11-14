Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYKNAbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYKNAbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYKNAbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:31:35 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:25655 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbYKNAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:31:34 -0500
Message-ID: <491CC6D4.2080604@caviumnetworks.com>
Date: Thu, 13 Nov 2008 16:31:16 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] New IDE/block driver for OCTEON SOC Compact Flash interface.
References: <491C7F28.2070507@caviumnetworks.com> <491CC0B6.8020400@ru.mvista.com>
In-Reply-To: <491CC0B6.8020400@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Nov 2008 00:31:16.0372 (UTC) FILETIME=[4E3AE540:01C945F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> David Daney wrote:
> 
>> As part of our efforts to get the Cavium OCTEON processor support
>> merged (see: http://marc.info/?l=linux-mips&m=122600487218824), we
>> have this CF driver for your consideration.
>>
>> Most OCTEON variants have *no* DMA or interrupt support on the CF
>> interface so a simple bit-banging approach is taken.  Although if DMA is
>> available, we do take advantage of it.
>>
>> The register definitions are part of the chip support patch set
>> mentioned above, and are not included here.
>>
>> At this point I would like to get feedback as to whether this is a
>> good approach for the CF driver, or perhaps generate ideas about other
>> possible approaches.
> 
>   It's totally unacceptable for drivers/ide/ as this is self-containeed 
> driver no using IDE core for anything, so this can only fit well to 
> drivers/block/.

Not quite true, it is using ide_fix_driveid() and ide_fixstring(), but I 
get your point.

> OTOH, CF support via self-contained driver is certainly a waste of code 
> since IDE core and (libata) are here to drive the CF devices as well. 
> What we need is a "normal" IDE or libata (at your option) driver.

I will have to try it to see if the hardware has the necessary support.

Thanks,
David Daney
