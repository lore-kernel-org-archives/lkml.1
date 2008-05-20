Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbYETJHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbYETJHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760638AbYETJGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:06:50 -0400
Received: from gw.goop.org ([64.81.55.164]:44020 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635AbYETJGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:06:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 8] x86: use PTE_MASK consistently
Message-Id: <patchbomb.1211268376@localhost>
Date: Tue, 20 May 2008 08:26:16 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Repost due to screwed up mail headers. ]

Hi all,

Here's a series to rationalize the use of PTE_MASK and remove some
amount of ad-hocery.

This gist of the series is:
 1. Fix the definition of PTE_MASK so that its equally applicable in
    all pagetable modes
 2. Use it consistently

I haven't tried to address the *_bad() stuff, other than to convert
pmd_bad_* to use PTE_MASK.

This series has had some testing in the x86.git tree, and hasn't shown
any problems.  Each patch is more or less absolutely trivial and the
series is very bisectable, to help track down any problems which might
arise (this area has always been a source of subtle problems).

      J

