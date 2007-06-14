Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbXFNQ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbXFNQ7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXFNQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:59:07 -0400
Received: from smtp-0-1.linuxrulz.org ([64.191.81.102]:49291 "EHLO
	smtp-0-1.linuxrulz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXFNQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:59:06 -0400
Message-ID: <467173C4.1050500@lbsd.net>
Date: Thu, 14 Jun 2007 16:58:44 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA problems
References: <8vX5T-4hg-5@gated-at.bofh.it> <8w0n1-15u-27@gated-at.bofh.it>
In-Reply-To: <8w0n1-15u-27@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>> I'm stumped trying to track down the below intermittent problem.....
>>
>> I've confirmed this problem on 2.6.19, 2.6.20 and 2.6.21.
>>
>> Any help greatly appreciated!
>>
>> Regards
>> Nigel
>>
>>
>> Jun 14 07:55:52 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x2 frozen
>> Jun 14 07:55:52 nigel-m2v kernel: ata2.00: cmd
>> ca/00:18:87:e7:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 12288 out
>> Jun 14 07:55:52 nigel-m2v kernel:          res
>> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Jun 14 07:55:52 nigel-m2v kernel: ata2: soft resetting port
>> Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
>> 0x0001c807
>> Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
>> 0x0001c807
>> Jun 14 07:56:22 nigel-m2v kernel: ata2.00: qc timeout (cmd 0xef)
>> Jun 14 07:56:22 nigel-m2v kernel: ata2.00: failed to set xfermode
>> (err_mask=0x4)
> 
> Try 2.6.22-rc4-gitX...
> 
>     Jeff

Hi Jeff,

Is there a patch in particular I can maybe apply? I see you made a
couple of commits ... my problem is this is also happening on one of my
production boxes which has a few other patches applied, I'm a bit scared
of conflicts ... I don't really want to break anything by upgrading the
kernel.


Kind Regards
Nigel




