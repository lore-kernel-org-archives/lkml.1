Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXFXLH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXFXLH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 07:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbXFXLHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 07:07:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35047 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbXFXLHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 07:07:50 -0400
Date: Sun, 24 Jun 2007 13:07:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070624110746.GA28868@elte.hu>
References: <20070622220202.GA16872@elte.hu> <5486cca80706230322k6e3c0f81u8e3d149ca04dc041@mail.gmail.com> <20070623172557.GA27435@elte.hu> <5486cca80706240302mdebff81qaeaea9699ceb8564@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486cca80706240302mdebff81qaeaea9699ceb8564@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Antonino Ingargiola <tritemio@gmail.com> wrote:

> Anyway, I've discovered with great pleasure that CFS has also the 
> SCHED_ISO priority. I may have missed something, but I don't remember 
> to have read this in any of the CFS release notes :). For me this is a 
> really useful feature. Thanks.

well, it's only a hack and emulated: SCHED_ISO in CFS is recognized as a 
policy but it falls back to SCHED_NORMAL. Could you check how well this 
(i.e. SCHED_NORMAL) works for your workload, compared to SD's SCHED_ISO? 
If you'd like to increase the priority of a task, i'd suggest to use 
negative nice levels. (use the 'nice' option in 
/etc/security/limits.conf with a newer version of PAM to allow 
unprivileged users to use negative nice levels.)

	Ingo
