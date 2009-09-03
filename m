Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbZICVAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbZICVAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbZICVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:00:06 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:40491 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbZICVAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:00:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19104.11857.497247.438179@pilspetsen.it.uu.se>
Date: Thu, 3 Sep 2009 23:00:01 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <87pra89sgp.fsf@devron.myhome.or.jp>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<87pra89sgp.fsf@devron.myhome.or.jp>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi writes:
 > Well, anyway, I'd like to reproduce this on my machine. Could you tell
 > me the version of tools? I guess gcc testsuite using the gcc's source
 > (svn revision?), expect, dejagnu, tcl. (BTW, I'm using debian
 > testing. If it can be reproduced on kvm, I can install distro version
 > which you are using)

Nothing fancy needed. You can use the gcc-4.4.1 release tarball and any recent
gcc-4.3 weekly snapshot tarball, like 4.3-20090830.

I've always seen the bogus errors in the C or C++ testsuites, so to save
some time you can just --enable-languages=c,c++ when building gcc.

The machines I've been running the testsuites on are a mix of architectures
running older or stability-oriented distros:

M1: i686 PC, Fedora Core 6, dejagnu-1.4.4-5.1, expect-5.43.0-5.1, tcl-8.4.13-3.fc6
M2: powerpc64 (G5), YellowDog 6.2, dejagnu-1.4.4-5.1, expect-5.43.0-5.1, tcl-8.4.13-3
M3: ARM, FC8-based, dejagnu-1.4.4-12.fc8, expect-5.43.0-9.fc8, tcl-8.4.17-1.fc8

/Mikael
