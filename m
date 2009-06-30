Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZF3Veg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZF3Veg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbZF3Ve2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:34:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbZF3Ve1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:34:27 -0400
Date: Tue, 30 Jun 2009 23:34:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Wire up new syscalls
Message-ID: <20090630213406.GB17492@elte.hu>
References: <20090630212454.19294.75622.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630212454.19294.75622.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Wire up new syscalls rt_tgsigqueueinfo and perf_counter_open.

> +	.long sys_perf_counter_open

Hm, i suspect this should be sys_ni because FRV does not set 
HAVE_PERF_COUNTERS so perfcounters cannot be enabled. (Or do you 
have patches in the pipeline that enable perfcounters for FRV?)

	Ingo
