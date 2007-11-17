Return-Path: <linux-kernel-owner+w=401wt.eu-S1765390AbXKQTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765390AbXKQTZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761187AbXKQTZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:25:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:51066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760828AbXKQTZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:25:26 -0500
Date: Sat, 17 Nov 2007 19:25:25 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35.4
Message-ID: <20071117192525.GA2078@hera.kernel.org>
Reply-To: w@1wt.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.4.35.4.

It fixes very minor issues, but some patches have been resting here
for a long time, and there was no reason to hold them. Two minor
old vulnerabilities were fixed :
 - CVE-2006-5823 would cause the kernel to oops on specially crafted
   CRAMFS filesystems, though on 2.4.35 we never got more than an
   error in the logs. The fix was merged anyway.
 - CVE-2004-2731 corresponds to an incorrect size check in sparc's
   openprom driver. It was fixed in 2.5 but not in 2.4.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.35.4.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.35.4

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.35.y.git


Regards,
Willy

---

Summary of changes from v2.4.35.3 to v2.4.35.4
============================================

Franck Bourdonnec (1):
      fix missing MODULE_LICENSE in some drivers

Gilles Espinasse (1):
      fix unresolved symbols on alpha

Moritz Muehlenhoff (1):
      corrupted cramfs filesystems cause kernel oops (CVE-2006-5823)

Tony Battersby (1):
      sym53c8xx_2 SMP deadlock on driver load

Willy Tarreau (2):
      PPP: fix crash using usb-serial on high speed devices
      Change VERSION to 2.4.35.4

dann frazier (4):
      [OpenPROM]: Fix signedness bug in openprom char driver
      [OpenPROM]: Fix user-access checking bugs in openpromfs
      [OpenPROM] Prevent overflow of sprintf buffer
      [OpenPROM] Prevent unsigned roll-overs in

