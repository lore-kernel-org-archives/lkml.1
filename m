Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbXIOWaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbXIOWaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 18:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXIOWaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 18:30:06 -0400
Received: from inti.inf.utfsm.cl ([200.1.21.155]:44676 "EHLO inti.inf.utfsm.cl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbXIOWaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 18:30:04 -0400
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 18:30:03 EDT
Message-Id: <200709152137.l8FLbtXP001446@laptop13.inf.utfsm.cl>
To: sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SPARC{,64}: kernel_termios_to_user_termios_1 missing
X-Mailer: MH-E 7.4.2; nmh 1.2-20070115cvs; XEmacs 21.5  (beta28)
Date: Sat, 15 Sep 2007 17:37:55 -0400
From: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
X-Greylist: Delayed for 00:23:57 by milter-greylist-3.0rc6 (inti.inf.utfsm.cl [0.0.0.0]); Sat, 15 Sep 2007 18:01:56 -0400 (CLT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

git-describe says this is v2.6.23-rc6-168-g53a3f30
I'm getting:

  drivers/char/tty_ioctl.c: In function 'n_tty_ioctl':
  drivers/char/tty_ioctl.c:799: error: implicit declaration of function 'kernel_termios_to_user_termios_1'

This is a macro at the very end of include/asm-<foo>/termios.h for i686, on
SPARC and SPARC64 it is missing. Sorry, I've got no clue on how to define
this correctly here.

It is also missing on alpha, blackfin, parisc, sh64, sh, xtensa
-- 
Dr. Horst H. von Brand                   User #22616 counter.li.org
Departamento de Informatica                    Fono: +56 32 2654431
Universidad Tecnica Federico Santa Maria             +56 32 2654239
Casilla 110-V, Valparaiso, Chile               Fax:  +56 32 2797513

