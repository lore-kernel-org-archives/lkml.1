Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbYFFRPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbYFFRPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 13:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYFFRP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 13:15:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbYFFRP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:15:27 -0400
Date: Fri, 6 Jun 2008 19:15:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606171511.GC18524@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au> <20080605195604.41623687.akpm@linux-foundation.org> <20080606071707.GB9708@elte.hu> <20080606002957.6329a0ec.akpm@linux-foundation.org> <20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606035413.37f340ef.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> 	    x86: remove the static 256k node_to_cpumask_map
> 
> crash, as described earlier.
> 
> I don't know what happened to that early exception - it didn't come back.

hm, early exception, there's one commit i can think of right now:

 # tip/x86/xen: b20aecc: xen: fix early bootup crash on native hardware

but that got propagated to linux-next:

 # linux-next: b20aecc: xen: fix early bootup crash on native hardware

	Ingo
