Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXL3Ork@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXL3Ork (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXL3Ord
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:47:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXL3Orc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:47:32 -0500
Date: Sun, 30 Dec 2007 15:47:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] forcedeth: seperate handler for msix and normal int.
Message-ID: <20071230144708.GQ16946@elte.hu>
References: <200712291415.47835.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712291415.47835.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1127]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] forcedeth: seperate handler for msix and normal int.
> 
> so we don't need to keep checking np->msi_flags to see if 
> NV_MSI_X_ENABLED is set in handler

hm, why is this patch needed and what's the effect of this patch?

i'm also wondering, what happened to Jeff's very nice flow cleanups and 
simplifications to forcedeth.c. They are not in 2.6.24 - are they queued 
up for 2.6.25 perhaps?

	Ingo
