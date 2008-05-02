Return-Path: <linux-kernel-owner+w=401wt.eu-S964861AbYEBMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbYEBMnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763869AbYEBMnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:43:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40850 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbYEBMnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:43:03 -0400
Date: Fri, 2 May 2008 15:42:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: How to reduce the number of open kernel bugs
Message-ID: <20080502124210.GB5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just seen in the kernel Bugzilla (driver anonymized to foobar):


Submitter [opens bug]:

Hardware Environment: See my other reports

This just happens while I were on surfing in the internet:
[ WARN_ON() traces involving driver foobar ]


Adrian [adds driver maintainer to Cc]


Maintainer [closes bug]:

Your hardware is seriously broken.


Submitter [reopens bug]:

Thanks for your answer, but I think that my hardware isn't broken, 
because all my reported issues don't occur on Windows and also not with 
foobaz.


Maintainer [closes bug]:

Then something in the chipset of PCI bus driver is broken. Also note the 
APIC errors. This certainly is not a foobar bug. The driver is just 
unable to access the card through the PCI bus, so it throws errors.


Submitter:

Interesting.

The APIC CPU errors are there since I've got the laptop, with and 
without foobar ;)


Maintainer:

Yeah, in any case. I cannot fix it, since it's not a bug in the fobar
code. Please reopen a new bug and CC the architecture or PCI maintainer 
or whatever person related to the bus, chipset or CPU, if you think the 
foobar device still works. If the foobar hardware got corrupted, you 
already know what to do...





I am well aware that loud flames are often the only working way of 
communication in Linux kernel development, but we mustn't communicate 
this way with bug submitters.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

