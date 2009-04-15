Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbZDOT3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbZDOT3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZDOT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:29:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbZDOT3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:29:17 -0400
Date: Wed, 15 Apr 2009 21:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, x86@kernel.org,
       sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [git-pull -tip] Add -Werror to arch/x86/ files only and fix
	warnings
Message-ID: <20090415192802.GB27004@elte.hu>
References: <1239793458.7653.12.camel@ht.satnam> <20090415122251.beba3b43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415122251.beba3b43.akpm@linux-foundation.org>
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

> On Wed, 15 Apr 2009 16:34:18 +0530
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > I added -Werror for x86/files only
> 
> yikes.
> 
> Not only does this need to be tested for all configs, it also need 
> to be tested for all approved gcc versions.
> 
> For example, one of my compilers always spews warnings from x86 
> because it has the "foo(&bar) doesn't initialise bar" stupidity.
> 
> And there will be other gcc inconsitencies, for sure.

Yes.

> > Subject: [PATCH-tip] x86: Adding -Werror to arch/x86/ files only 
> > for !CONFIG_ALLOW_X86_WARNINGS
> 
> whew, that sounds better.

Yes, as requested by an equally worried x86 maintainer ;-)

	Ingo
