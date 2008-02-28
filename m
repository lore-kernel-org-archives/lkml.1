Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbYB1SiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbYB1SiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYB1SiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:38:06 -0500
Received: from mail.tmr.com ([64.65.253.246]:52509 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbYB1SiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:38:05 -0500
Message-ID: <47C70067.6060205@tmr.com>
Date: Thu, 28 Feb 2008 13:41:43 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
References: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de> <E1JR1e0-0001R1-IR@faramir.fjphome.nl>
In-Reply-To: <E1JR1e0-0001R1-IR@faramir.fjphome.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Joerg Schilling wrote:
>> This fragment is much too short to allow to judge on possible reasons.
>> There is a high probability that your problem is caused by the cdrecord
>> fork called "wodim".
> 
> There is also the 100% certainty that this reply was from a known troll and
> should just be ignored.

Actually he is the author of the software in question, and has 
maintained it for a decade. Anyone who reads the cdwrite mailing list 
knows that I have criticized his endless whining that Linux doesn't do 
things right, but aside from the cosole output whining about Linux from 
his program[1], and the fact that it must run as root[2], the real 
cdrecord works in more cases, with more hardware, produces working burns 
in more cases, and has more useful output, and is the software to use in 
preference to wodim.

[1] cdrecord advises to use Linux 2.4 (and I think Solaris), and says 
you should avoid using readable names for devices and use some 
pseudo-SCSI numbers he likes instead.

[2] Linux developers filter commands sent to devices to protect them 
from commands like erase BIOS. Joerg uses vendor proprietary commands 
for greater functionality, and says if you have write on the device it 
shouldn't be filtered and those commands should be permitted by the 
filter. (That is a simplification, there are personal issues on both sides).

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
