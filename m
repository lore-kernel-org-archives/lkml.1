Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbYIUPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbYIUPyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 11:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYIUPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 11:54:09 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:39144 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYIUPyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 11:54:08 -0400
Date: Sun, 21 Sep 2008 19:53:17 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bernhard.weirich@riedel.net
Subject: Re: [1/1] w1: new driver. DS2431 chip.
Message-ID: <20080921155317.GB19601@2ka.mipt.ru>
References: <20080917154928.GB490@2ka.mipt.ru> <20080917160007.1fc58f28.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917160007.1fc58f28.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 04:00:07PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 17 Sep 2008 19:49:29 +0400
> Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > Signed-off-by: Bernhard Weirich <bernhard.weirich@riedel.net>
> > Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> This was authored by Bernhard, but the way in which it was sent claims
> that it was authored by yourself.  Please add a From: line at the very
> top of the changelog body to indicate authorship.

Ok, I see. Patch was definitely created by Bernhard, I just pointed to
couple of trivial cleanups. I saw you imported it into the tree with
your fixes, thanks a lot!

> > --- linux-2.6.25.3/drivers/w1/slaves/w1_ds2431.c	1970-01-01 01:00:00.000000000 +0100
> > +++ linux-2.6.26.5/drivers/w1/slaves/w1_ds2431.c	2008-09-17 09:02:13.000000000 +0200
> > @@ -0,0 +1,318 @@
> > +/*
> > + *	w1_DS2431.c - w1 family 2d (DS2431) driver
> 
> case-insensitive filenames? ;)

Fortunately only comment :)

> > +/**
> > + * Check the file size bounds and adjusts count as needed.
> > + * This would not be needed if the file size didn't reset to 0 after a write.
> > + */
> 
> The driver has a number of comments whcih start with /**.  But that
> pattern is specifically used to flag the presence of a kerneldoc-format
> comment.  And these comments are in fact not in kerneldoc form.

I think we need to drop ** lines, since I did not convert kernel
comments into documentation, so would not be able to point to kerneldoc
(its doxygen iirc?) errors anyway.

-- 
	Evgeniy Polyakov
