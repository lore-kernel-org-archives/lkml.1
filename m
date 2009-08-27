Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbZH1Jyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbZH1Jyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZH1Jyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:54:44 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:40339 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZH1Jyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:54:44 -0400
X-Greylist: delayed 5232 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 05:54:43 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19094.58486.867940.103340@pilspetsen.it.uu.se>
Date: Thu, 27 Aug 2009 21:54:30 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <_yaHeGjHEzG.A.tMH.9sGlKB@chimera>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<_yaHeGjHEzG.A.tMH.9sGlKB@chimera>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 22:34:53 +0200 (CEST), Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
> Subject		: pty regressed again, breaking expect and gcc's testsuite
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-08-14 23:41 (12 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4

Not fixed. With 2.6.31-rc7 I'm still seeing repeatable testsuite
failures on powerpc64. Reverting to 2.6.30 makes the failures go away.
