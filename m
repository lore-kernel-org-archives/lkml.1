Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbXLOSNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbXLOSNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 13:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbXLOSNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 13:13:10 -0500
Received: from waste.org ([66.93.16.53]:47247 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbXLOSNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 13:13:08 -0500
Date: Sat, 15 Dec 2007 12:12:54 -0600
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
Message-ID: <20071215181254.GU17536@waste.org>
References: <20071214132755.GA18309@gondor.apana.org.au> <1197700290.6696.52.camel@pasglop> <20071215063442.GA26491@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215063442.GA26491@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 02:34:42PM +0800, Herbert Xu wrote:
> On Sat, Dec 15, 2007 at 05:31:30PM +1100, Benjamin Herrenschmidt wrote:
> >
> > That's something I've actually never quite liked... the fact that we
> > evaluate the expression anyway. I'm pretty happy with -not- evaluating
> > the expression when CONFIG_BUG is on most of the time since whatever is
> > in there is purely here for the sake of the BUG/WARN test.
> 
> Whether we evaluate the expression is a completely different debate.
> I personally agree with you that expressions that have side-effects
> are a stupid idea for either WARN_ON or BUG_ON.

As do I. But we can't really do anything about it short of auditing
them all.

-- 
Mathematics is the supreme nostalgia of our time.
