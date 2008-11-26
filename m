Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYKZI2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYKZI2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYKZI17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:27:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbYKZI16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:27:58 -0500
Date: Wed, 26 Nov 2008 09:27:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print
	oops dumps
Message-ID: <20081126082744.GL26036@elte.hu>
References: <20081123130042.1d194768@infradead.org> <20081126072445.GG26036@elte.hu> <20081126001234.19c9a7b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126001234.19c9a7b0.akpm@linux-foundation.org>
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

> On Wed, 26 Nov 2008 08:24:45 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >  scripts/markup_oops.pl |  162 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 162 insertions(+), 0 deletions(-)
> > >  create mode 100644 scripts/markup_oops.pl
> > 
> > looks useful - Andrew, Sam, any objections to this?
> 
> who-me-no-i-already-merged-it.
> 
> I didn't test it though - I don't have particularly high hopes given 
> the general deadness of `make mm/memory.lst' for the past numerous 
> years.
> 
> But it's worth trying.  The challenge will be getting people to 
> remember that it exists, and to use it.
> 
> I often turn off CONFIG_DEUG_INFO because it slows builds down so 
> much. It is irritating when such a kernel goes splat.

i keep DEBUG_INFO turned off all the time, and only turn it on if 
really needed. But in that case i can just turn it on and rebuild: 
recent gccs seem better at keeping the image unmodified. (or at least 
so i kid myself)

Years ago the image would mute a bit with DEBUG_INFO enabled, making 
the splat info fuzzy. Seems better now.

	Ingo
