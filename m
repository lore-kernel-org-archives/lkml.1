Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbYARNDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbYARNDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbYARNDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:03:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60189 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962AbYARNDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:03:04 -0500
Date: Fri, 18 Jan 2008 14:02:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, ebiederm@xmission.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: checking aperture report for node instead
	of?cpu v2
Message-ID: <20080118130243.GS11044@elte.hu>
References: <200801101914.47967.yinghai.lu@sun.com> <200801141739.35448.yinghai.lu@sun.com> <20080115132253.GC7025@elte.hu> <200801151031.46279.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801151031.46279.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> "
> Checking aperture...
> CPU 0: aperture @4000000 size 64MB
> CPU 1: aperture @4000000 size 64MB
> "
> we should use use Node instead.
> 
> we will get
> "
> Checking aperture...
> Node 0: aperture @4000000 size 64MB
> Node 1: aperture @4000000 size 64MB
> "

thanks, applied.

	Ingo
