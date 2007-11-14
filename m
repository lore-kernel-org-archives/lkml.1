Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXKNN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXKNN4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbXKNN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:56:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXKNN4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:56:10 -0500
Date: Wed, 14 Nov 2007 14:56:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: Divide-by-zero in the 2.6.23 scheduler code
Message-ID: <20071114135605.GC3739@elte.hu>
References: <473A4C0F.6070504@redhat.com> <1195046856.6924.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195046856.6924.21.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> As for the patch, better to just rip out the entire feature..

for -stable it's safer to have smaller patches - so this patch is 
perfectly fine. A user can turn it back on under SCHED_DEBUG and by 
tweaking a debug flag - but that's not a big issue, you can mess up the 
system in numerous ways via /proc/sys anyway. So i'd suggest Chuck's 
patch for -stable.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo

