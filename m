Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbYFFIhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbYFFIhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYFFIhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:37:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbYFFIhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:37:07 -0400
Date: Fri, 6 Jun 2008 10:36:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606083639.GD10826@elte.hu>
References: <20080605195604.41623687.akpm@linux-foundation.org> <20080606071707.GB9708@elte.hu> <20080606072536.GA19334@elte.hu> <20080606003327.9ac0e91b.akpm@linux-foundation.org> <20080606074137.GA28962@elte.hu> <20080606004743.a78180c3.akpm@linux-foundation.org> <20080606175358.a439d1bb.sfr@canb.auug.org.au> <20080606010149.4d757b92.akpm@linux-foundation.org> <20080606182206.8bc36f71.sfr@canb.auug.org.au> <20080606013058.e5d52c97.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606013058.e5d52c97.akpm@linux-foundation.org>
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

> > Each tree is fine on its own if you go one step back from the merge.
> 
> Well OK.  But patches in fact _do_ go into Linux as a single linear 
> stream of commits.  But the whole git model ignores that reality and 
> here we see the result.

it's fixable via "git-merge -n" and then doing a second git-merge, to 
create only a single commit. OTOH, it's more transparent to have such 
manual fixups in a followup commit.

	Ingo
