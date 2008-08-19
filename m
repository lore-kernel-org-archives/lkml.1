Return-Path: <linux-kernel-owner+w=401wt.eu-S1750862AbYHSKoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862AbYHSKoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYHSKoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:44:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYHSKoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:44:11 -0400
Message-Id: <20080819103301.787700742@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 12:33:01 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/6] sched: rt-bandwidth fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series brings some fixes to the rt-badnwidth code
and at the very end disables it by default.

Patches 4 and 5 are probably too large at this point in the release
cycle - and only affect CONFIG_RT_GROUP_SCHED which is still marked
EXPERIMENTAL and has never been enabled by default - so we could skip
those.

