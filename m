Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYDJGw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYDJGw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbYDJGwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:52:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbYDJGwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:52:44 -0400
Date: Thu, 10 Apr 2008 08:52:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-ID: <20080410065227.GB30066@elte.hu>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FCF50E.9090703@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCF50E.9090703@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Stephen Rothwell wrote:
> > There were a few merge conflicts (fairly trivial) and couple of build
> > failures (notified).  There is a know build failure with powerpc
> > allyesconfig.  Below is a summary of the state of the merge.
> ...
> > Merging ieee1394/for-next
> > CONFLICT (content): Merge conflict in lib/Kconfig.debug
> 
> Would it be safe for me (and preferred by you) to merge sched/for-akpm 
> into ieee1394/for-next to resolve this conflict until next mainline 
> merge?

what type of conflict do you have there? If it's a new entry then you 
might be able to fix it by moving the new entry elsewhere in the file. 
Or if i introduced a new entry close to an existing entry you modify 
then i could move my new entry elsewhere.

	Ingo
