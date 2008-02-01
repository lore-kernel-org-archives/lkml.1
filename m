Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbYBASnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbYBASnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYBASm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:42:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:49145 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754951AbYBASm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:42:57 -0500
Cc: Mel Gorman <mel@csn.ul.ie>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 01 Feb 2008 19:42:54 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
Message-ID: <20080201184254.174020@gmx.net>
MIME-Version: 1.0
Subject: Commit for mm/page_alloc.c breaks boot process on my machine
To: linux-kernel@vger.kernel.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+EpF4+ZZiELIBAxk7LyNX3fWfSi1Mru7kVlzp9Af
 zkGiGwizLEcyMKuB4CPpEjG8up/XRmg24luA== 
X-GMX-UID: TwHWdM52ODB6dkRrLmRM3bE9Ji9SWlJi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to get the 2.6.24 Linux kernel booting on my AmigaOne machine
(it's a desktop PowerPC G4 machine with 1.5GB RAM). I have written the
device tree and platform setup files for arch/powerpc, which seem to be
working so far.
Kernel version 2.6.24-rc2 was booting fine with my patches until the
kernel executes the INIT command. But kernel release v2.6.24 dies early
during the boot process (even before the radeonfb driver initializes and
outputs kernel messages). Bisecting revealed that this commit causes my
machine to fail booting:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=44048d700bcbfaf4bcca6e2e0a73d89d01ec0878
(Revert "Bias the placement of kernel pages at lower PFNs")

The machine boots fine, if I revert the patch. But I wonder what side
effects this patch may have? Can somebody shed some light on this?

Thanks!

regards,

Gerhard

BTW: Please put me on CC: as I'm not subscribed to this list.

-- 
GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
