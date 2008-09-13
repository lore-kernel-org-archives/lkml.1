Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYIMUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYIMUfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYIMUfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 16:35:21 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:35544 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIMUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 16:35:21 -0400
Date: Sat, 13 Sep 2008 15:32:48 -0500
From: David Fries <david@fries.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Paul Gortmaker <paul.gortmaker@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ne.c Fix suspend and resume for ISA PnP cards.
Message-ID: <20080913203248.GP7877@spacedout.fries.net>
References: <20080904030212.GA23493@spacedout.fries.net> <7d1d9c250809050101v9ab3907l649781ee38a5a243@mail.gmail.com> <20080909025434.GB28469@spacedout.fries.net> <20080909030114.GC28469@spacedout.fries.net> <48CC1ABC.3090903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CC1ABC.3090903@garzik.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sat, 13 Sep 2008 15:32:53 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 03:55:40PM -0400, Jeff Garzik wrote:
> David Fries wrote:
> >From: David Fries <david@fries.net>
> >
> >A call to pnp_stop_dev and pnp_start_dev now shuts down and
> >initializes plug and play devices for suspend and resume.
> >
> >Signed-off-by: David Fries <david@fries.net>
> >Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> >Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
> >Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> >Cc: Jeff Garzik <jeff@garzik.org>
> >---
> > drivers/net/ne.c |    9 ++++++++-
> > 1 files changed, 8 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/net/ne.c b/drivers/net/ne.c
> >index 2bece66..cd31e77 100644
> 
> applied

I just wanted to make it clear for anyone testing, this patch 2/2 by
itself changes suspend and resume functions which aren't executed
without patch 1/2 "ne.c fix rmmod, platform driver improvements".  

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
