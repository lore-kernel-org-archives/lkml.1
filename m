Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbYFJKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbYFJKJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYFJKJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:09:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYFJKJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:09:26 -0400
Date: Tue, 10 Jun 2008 12:09:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Replace xxx_pda() operations with
	x86_xx_percpu().
Message-ID: <20080610100907.GL27706@elte.hu>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.711845000@polaris-admin.engr.sgi.com> <20080609130302.GA20943@elte.hu> <484D6A05.7010508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484D6A05.7010508@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >>   * It is now possible to use percpu operations for pda access
> >>     since the pda is in the percpu area. Drop the pda operations.
> > 
> > FYI, this one didnt build with the attached config.
> > 
> > 	Ingo
> > 
> 
> Hi Ingo,
> 
> Can you send me the output from the build?  It builds fine on my 
> machine (a few warnings).  The silentoldconfig made these changes to 
> the .config file.  (I did a git-remote update and reapplied my changes 
> before building.)

dont have the log anymore, but i had to revert 3/4 due to the boot 
crash, could there be a dependency of 4/4 on 3/4?

the first two patches look fine and survived -tip testing.

	Ingo
