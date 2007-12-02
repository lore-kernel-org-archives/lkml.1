Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbXLBVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbXLBVYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXLBVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:24:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbXLBVY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:24:28 -0500
Date: Sun, 2 Dec 2007 22:24:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202212407.GA11358@elte.hu>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202211027.GA32282@elte.hu> <20071202211925.GA26414@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202211925.GA26414@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> On Sun, Dec 02, 2007 at 10:10:27PM +0100, Ingo Molnar wrote:
> > what if you considered - just for a minute - the possibility of this 
> > debug tool being the thing that actually animates developers to fix such 
> > long delay bugs that have bothered users for almost a decade meanwhile?
> 
> Throwing frequent debugging messages for non buggy cases will just 
> lead to people generally ignore softlockups.

do you realize that more than 120 seconds TASK_UNINTERRUPTIBLE _is_ 
something that most humans consider as "buggy" in the overwhelming 
majority of cases, regardless of the reason? Yes, there are and will be 
some exceptions, but not nearly as countless as you try to paint it. A 
quick test in the next -mm will give us a good idea about the ratio of 
false positives.

	Ingo
