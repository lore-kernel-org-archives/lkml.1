Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZCKK2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZCKK2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCKK2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:28:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbZCKK2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:28:37 -0400
Date: Wed, 11 Mar 2009 11:28:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH for -tip] x86, mce: use round_jiffies() instead
	round_jiffies_relative()
Message-ID: <20090311102823.GA2157@elte.hu>
References: <20090311100925.A7FA.A69D9226@jp.fujitsu.com> <20090311021405.GE11935@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311021405.GE11935@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Mar 11, 2009 at 10:14:26AM +0900, KOSAKI Motohiro wrote:
> > Impact: saving power _very_ little
> > 
> > round_jiffies() round up absolute jiffies to full second.
> > round_jiffies_relative() round up relative jiffies to full second.
> > 
> > The "t->expires" is absolute jiffies. Then, round_jiffies() should be
> > used instead round_jiffies_relative().
> 
> Thanks. I have a rewrite of this code pending. I added it to 
> this.

It's already queued up in tip:x86/mce2.

	Ingo
