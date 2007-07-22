Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbXGVRI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbXGVRI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbXGVRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:08:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:36910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbXGVRIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:08:50 -0400
Date: Sun, 22 Jul 2007 17:08:45 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35-rc1
Message-ID: <20070722170845.GA5194@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I've just released Linux 2.4.35-rc1. Nothing critical, two bugs fixed,
a few PCI ID updates and the ability to disable TSC usage on x86_64 by
specifying "notsc" on the command line for users of broken dual-core
systems with no HPET and unsynced TSC.

My patch queue is empty and I'm satisfied with current code quality.
I will probably release -final by the end of the week if nobody reports
a missing fix till then. That way, people will be able to plan upgrades
of production systems during the holidays.

I will announce 2.4.34-stable in a separate mail.

Willy
--

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35-rc1.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


Summary of changes from v2.4.35-pre5 to v2.4.35-rc1
============================================

Filippo Carletti (2):
      2.4.34 - VIA VT8237A support
      Add some AHCI PCI IDs

Krzysztof Strasburger (1):
      notsc support for x86_64

Lior Dotan (1):
      Fix divide by 0 in vegas_cong_avoid()

PaX Team (1):
      random device reseed bugfix, possibly security problem

Vincent Bernat (1):
      SATA update: add ICH8 PCI IDs

Willy Tarreau (2):
      Documentations/SubmittingPatches was outdated
      Change VERSION to 2.4.35-rc1

