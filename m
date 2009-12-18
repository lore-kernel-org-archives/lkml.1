Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbZLRVv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbZLRVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932727AbZLRVv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:51:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZLRVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:51:27 -0500
Date: Fri, 18 Dec 2009 22:51:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
Message-ID: <20091218215107.GA14946@elte.hu>
References: <4B1D4F29.8020309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D4F29.8020309@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <gregory.haskins@gmail.com> wrote:

> Hi Linus,
> 
> Please pull AlacrityVM guest support for 2.6.33 from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/alacrityvm/linux-2.6.git
> for-linus
> 
> All of these patches have stewed in linux-next for quite a while now:
> 
> Gregory Haskins (26):

I think it would be fair to point out that these patches have been objected to 
by the KVM folks quite extensively, on multiple technical grounds - as 
basically this tree forks the KVM driver space for which no valid technical 
reason could be offered by you in a 100+ mails long discussion.

(And yes, i've been Cc:-ed to much of that thread.)

The result will IMO be pain for users because now we'll have two frameworks, 
tooling incompatibilities, etc. etc.

I've extended the Cc: for the KVM folks to have a chance to reply. Please try 
_much_ harder to work with the KVM folks instead of ignoring their feedback 
and de-facto forking their project. (and not mentioning any of this in your 
pull request) We should unify, not fracture.

	Ingo
