Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYGRL4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYGRL4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYGRL4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:56:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbYGRL4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:56:39 -0400
Date: Fri, 18 Jul 2008 13:56:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: ghaskins@novell.com, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix inc_rt_tasks() to not declare variable 'rq' if
	it's not needed
Message-ID: <20080718115620.GI6875@elte.hu>
References: <20080711123454.10475.33099.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711123454.10475.33099.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Howells <dhowells@redhat.com> wrote:

> Fix inc_rt_tasks() to not declare variable 'rq' if it's not needed.  It is
> declared if CONFIG_SMP or CONFIG_RT_GROUP_SCHED, but only used if CONFIG_SMP.
> 
> This is a consequence of patch 
> 1f11eb6a8bc92536d9e93ead48fa3ffbd1478571 plus patch 
> 1100ac91b6af02d8639d518fad5b434b1bf44ed6.

applied, thanks David.

	Ingo
