Return-Path: <linux-kernel-owner+w=401wt.eu-S1751196AbXB1Cnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbXB1Cnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 21:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXB1Cnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 21:43:35 -0500
Received: from mail.tmr.com ([64.65.253.246]:53359 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbXB1Cne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 21:43:34 -0500
Message-ID: <45E4EC08.50409@tmr.com>
Date: Tue, 27 Feb 2007 21:42:16 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rene Herman <rene.herman@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
   be mounted without hanging up the whole system
References: <20070226180635.GA644@tv-sign.ru> <Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org> <45E3493C.1040706@gmail.com> <Pine.LNX.4.64.0702261308490.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702261308490.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 26 Feb 2007, Rene Herman wrote:
>> Other than these two, ECP parallel ports are the other remaining users.
>> Now, even though on a machine that still has a parallel port it might usually
>> indeed be set to ECP in its BIOS; having anything attached to the port also
>> use it as such seems quite seldom.
> 
> Well, if it's some kind of cache coherency problem (the same way much more 
> modern CPU's have cache coherency issues with DMA during C3 sleep), then 
> it's entirely possible that the normal ECP parallel port behaviour would 
> never show it, since most people tend to use it for output only (yeah, I 
> realize you can use it bidirectionally, but at least on old hardware it 
> tends to be "talk AT printer" rather than "talk WITH printer".

The bidirectional use is/was PL/IP, aka "laplink" connections. Yes, I 
still have a machine I installed that way, and it will run 2.2.19 
forever before I try it again. ;-)
> 
> I frankly forget what hardware platforms had problems with the DMA thing, 
> and what the exact behaviour even was (I think there was some possibility 
> of corrupt data on the floppy). We also used to have the "nohlt" flag to 
> turn off hlt entirely, and that was due to some other legacy issues, iirc.
> 
> I seriously doubt we will ever see anybody who has this problem ever 
> again, but on the other hand, I also seriously doubt that most modern 
> machines even *have* a floppy drive any more, so I'd rather not even 
> change it. It's just not worth even a miniscule risk..

Thank you.
> 
> 		Linus


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
