Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZHXKJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZHXKJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 06:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZHXKJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 06:09:18 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64257 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbZHXKJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 06:09:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19090.26298.630328.344190@pilspetsen.it.uu.se>
Date: Mon, 24 Aug 2009 12:08:58 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <ADSuNT6McuD.A.wlH.nNIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	<ADSuNT6McuD.A.wlH.nNIjKB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 22:27:02 +0200 (CEST), Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
> Subject		: pty regressed again, breaking expect and gcc's testsuite
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-08-14 23:41 (6 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4

The good news is that I don't see this issue any more with 2.6.31-rc7
on x86. The bad news is that the first time I reported this issue, for
-rc3 or -rc4 I think, I thought it was fixed in -rc5 only to see it
reappear in -rc6 on x86 and in -rc5 on ARM. So I'd like to keep this
open another week while I run more regression tests on non-x86 platforms.

While I don't suspect any arch-specific problems in the pty/tty code,
I do suspect timing/race-type problems which are obviously affected
by platform speed etc.

/Mikael
