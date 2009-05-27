Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbZE0XVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbZE0XVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbZE0XVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:21:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbZE0XVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:21:02 -0400
Date: Thu, 28 May 2009 01:19:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, stable@kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh.dickins@tiscali.co.uk,
       Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       starlight@binnacle.cx, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org
Subject: Re: [PATCH 0/2] Fixes for hugetlbfs-related problems on shared
	memory
Message-ID: <20090527231949.GB30002@elte.hu>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie> <20090527131437.5870e342.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527131437.5870e342.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> On Wed, 27 May 2009 12:12:27 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The following two patches are required to fix problems reported by
> > starlight@binnacle.cx. The tests cases both involve two processes interacting
> > with shared memory segments backed by hugetlbfs.
> 
> Thanks.
> 
> Both of these address 
> http://bugzilla.kernel.org/show_bug.cgi?id=13302, yes? I added 
> that info to the changelogs, to close the loop.
> 
> Ingo, I'd propose merging both these together rather than routing 
> one via the x86 tree, OK?

sure.

> Question is: when?  Are we confident enough to merge it into 
> 2.6.30 now, or should we hold off for 2.6.30.1?  I guess we have a 
> week or more, and if the changes do break something, we can fix 
> that in 2.6.30.1 ;)

With an Acked-by from Hugh i feel pretty confident about it - and as 
long as it get into -rc8 i think we should do it in .30.

	Ingo 
