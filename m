Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZBDXu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZBDXu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbZBDXtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:49:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:58295 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759204AbZBDXtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:49:11 -0500
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <pWZw1SZjMCH.A.sIE.wuYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.sIE.wuYiJB@chimera>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 10:48:49 +1100
Message-Id: <1233791329.4612.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 11:24 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).

I still don't know what's the best way to handle that one... the bug is
in X and I don't see a way to work around it without removing support
for legacy memory access from the kernel :-( Or doing it in a way that
doesn't allow userspace to differenciate between the kernel not
supporting it vs. the HW not supporting it, causing X to fallback to
even more broken crap.

I'll try to find out the extent of the X problem and whether that's
fixable in a way that can hit distros.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12608
> Subject		: 2.6.29-rc powerpc G5 Xorg legacy_mem regression
> Submitter	: Hugh Dickins <hugh@veritas.com>
> Date		: 2009-01-21 21:12 (15 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3a54014e2a94bd37b7dee5e76e03f7bc4fab49a
> References	: http://marc.info/?l=linux-kernel&m=123257250431870&w=4
> Handled-By	: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 

