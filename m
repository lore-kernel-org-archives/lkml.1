Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXCJNM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXCJNM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 08:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXCJNM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 08:12:26 -0500
Received: from ints.mail.pike.ru ([85.30.199.194]:3030 "EHLO ints.mail.pike.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbXCJNM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 08:12:26 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 08:12:24 EST
Date: Sat, 10 Mar 2007 16:05:42 +0300
From: Vladimir <snigga@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070310160542.21cdb968@localhost>
Organization: MMA Sechenov, Clinic of cardiology
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the problem:
  1. Unpack the kernel sources, run make menuconfig.
  2. Mark the necessary options.
  3. Pick "Save an alternate configuration file", enter a filename (e.g. /root/kernelcfg)
  4. Pick "Exit".
->5. Configurator exits without saving. If type "make bzImage", it builtd all the default options.

And there's no ".config" file in kernel root directory, so i have to move there my "kernelcfg" and
rename it.

If i just run "make menuconfig", then pick "Exit", then it asks "Save kernel configuration?".

This happens starting from kernel 2.6.20 till 2.6.20.2
Slackware-current.
PC: Athlon-XP 2000+, 256 MB RAM.
Linux wolf 2.6.20.2 #1 SMP PREEMPT Sat Mar 10 15:41:42 MSK 2007 i686 athlon-4 i386 GNU/Linux
-- 
Faith manages.
