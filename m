Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbYDYKDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbYDYKDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 06:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbYDYKDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 06:03:35 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:38626 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383AbYDYKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 06:03:34 -0400
X-Greylist: delayed 1594 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2008 06:03:33 EDT
X-ClientAddr: 220.233.82.121
Message-ID: <4811A623.80104@itee.uq.edu.au>
Date: Fri, 25 Apr 2008 19:36:35 +1000
From: John Williams <jwilliams@itee.uq.edu.au>
User-Agent: Thunderbird 1.5.0.12 (X11/20080403)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com
Subject: Re: [microblaze-uclinux] Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804221515.28075.arnd@arndb.de> <480FA729.3000406@seznam.cz> <200804241311.09881.arnd@arndb.de> <4810D4A4.7050900@seznam.cz>
In-Reply-To: <4810D4A4.7050900@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Found to be clean
X-MailScanner-From: jwilliams@itee.uq.edu.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, Arnd,

Michal Simek wrote:


>>> 	.long sys_read
>>> 	.long sys_write
>>> 	.long sys_open			/* 5 */
>> Since we have all the new sys_*at calls like openat, we don't really
>> need the old versions any more. The kernel implementation of sys_open
>> basically calls openat. You could do the same in libc instead.
>> Don't know if that's worth it though, opinions?
> 
> I looked at it and there are the different arguments for open and openat
> syscalls. Implementation is almost the same. I keep it now.

Please remember that MicroBlaze has been around as an arch for > 4 
years, just not in the kernel.org tree.  These older style syscall 
interfaces are all part of the uClibc and glibc ports for MicroBlaze.

While I understand that there are shiny new ways of doing all this 
stuff, please don't break our C libraries, toolchains and all else.  A 
MicroBlaze arch in kernel.org that isn't actually supported by a C 
library or toolchain is not much use either!

Can we compromise and say that the new syscall interfaces will be added 
if they are currently missing, but older interfaces retained until the 
libs and toolchains catch up?

John

