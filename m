Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYCUNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYCUNmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYCUNln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:41:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbYCUNlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:41:42 -0400
Date: Fri, 21 Mar 2008 14:41:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-ID: <20080321134128.GO27245@elte.hu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4351.1205374751@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0970]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> I may have to try again to figure out how to bisect the git-x86 tree - 
> Ingo send me a pointer to his git-x86 cheat sheet, I looked at it but 
> I couldn't figure out how to tell 'git bisect' that the starting good 
> spot was "whatever corresponded to the git-x86 patch in 24-rc8-mm1" 
> and bad was "25-rc3-mm1". I tried using the first commit ID listed in 
> the patch, but that gave me this:

the best way to bisect the x86.git-only commits is to do:

  git-bisect bad x86/latest
  git-bisect good x86/base

the 'base' branch is the upstream tree that x86.git is based against. 
This will minimize the number of bisection points as well, because 
you'll only bisect x86.git patches.

[ and make sure you test x86/base first to establish that it's truly
  'good' :-) ]

	Ingo
