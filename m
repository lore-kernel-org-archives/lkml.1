Return-Path: <linux-kernel-owner+w=401wt.eu-S1030220AbXCLOqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220AbXCLOqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXCLOqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:46:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030263AbXCLOqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:46:21 -0400
Date: Mon, 12 Mar 2007 15:45:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] futex: PI state locking fix
Message-ID: <20070312144531.GA32109@elte.hu>
References: <20070312091342.GA27425@elte.hu> <45F56730.2050604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F56730.2050604@redhat.com>
User-Agent: Mutt/1.4.2.2i
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> > this patch has been tested in -rt. Must-have for v2.6.21.
> 
> Does that fix this:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=224262

yeah, could very much be related.

	Ingo
