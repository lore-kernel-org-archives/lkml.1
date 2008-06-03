Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYFCHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYFCHgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYFCHgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:36:01 -0400
Received: from aun.it.uu.se ([130.238.12.36]:49581 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYFCHgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:36:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18500.62552.958244.633204@harpo.it.uu.se>
Date: Tue, 3 Jun 2008 09:35:52 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While investigating a report in linux.debian.ports.sparc
saying that X doesn't work with the 2.6.24 kernel, I noticed
that while X works for me with 2.6.25, 2.6.24, and Aurora's
2.6.23 kernels, it doesn't work with any 2.6.26-rcN (1<=N<=4)
kernel; with those it always fails with a

Fatal server error:
xf86MapPciMem: Could not mmap PCI memory [base=0xe2000000,hostbase=0xe2000000,size=2000] (No such file or directory)

I'll start digging through 2.6.25->2.6.26-rc1 later today,
meanwhile I've put Xorg.0.log, Xorg strace, dmesg, and .config
files for 2.6.25 (working) and 2.6.26-rc4 (failing) in
<http://user.it.uu.se/~mikpe/linux/sparc64-2.6.26-rcN-xorg-bug/>.

/Mikael
