Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbXAWPag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbXAWPag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbXAWPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:30:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56993 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751997AbXAWPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:30:35 -0500
Date: Tue, 23 Jan 2007 15:41:27 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Pavel Machek <pavel@ucw.cz>, Samium Gromoff <_deepfire@feelingofgreen.ru>,
       Valdis.Kletnieks@vt.edu, David Wagner <daw@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Undo some of the pseudo-security madness
Message-ID: <20070123154127.57059632@localhost.localdomain>
In-Reply-To: <87mz4996wg.wl@betelheise.deep.net>
References: <87r6toufpp.wl@betelheise.deep.net>
	<200701221520.l0MFKLdK032645@turing-police.cc.vt.edu>
	<871wlnq7ue.wl@betelheise.deep.net>
	<20070123084805.GB5560@ucw.cz>
	<87mz4996wg.wl@betelheise.deep.net>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> SBCL is the most actively developed open source Common Lisp implementation,
> which has an optimising native compiler built in, so it is not an interpreter,
> and is, most certainly, not crappy.

If it requires MAP_FIXED I would beg to disagree.

> 1. cannot serve as a vehicle for exploitation for binaries unmarked
> with this flag
> 2. serve the application deployment cause -- abolish the need for
> application-specific system tweaks
> 3. remove the need for the ugly self-reexecution tweak people
> needing an absolutely unadulterated memory map have to resort to /now/,
> even in a non-setuid case 

Seems sensible to me. If you specifically need that mapping behaviour and
ask for it then it wouldn't be hard to provide.

> Please, shrug off that C-esque center-of-the-world attitude,
> the fact there are thousand times as many C programmers does not

Randomisation has nothing to do with C. In fact from a C perspective the
compiler and linker do a lot of work to deal with ELF and loading code at
arbitary addresses for dynamic linking and the like, not the user and
not as language constructs. Perhaps the Lisp universe should wake up and
meet the 1980s 8)


Alan
