Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYBEWsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYBEWsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762084AbYBEWsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:48:22 -0500
Received: from ozlabs.org ([203.10.76.45]:49207 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760785AbYBEWsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:48:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Whine about suspicious return values from module's ->init() hook
Date: Wed, 6 Feb 2008 09:48:10 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
References: <20080204154215.GA26618@localhost.sw.ru> <200802051708.37349.rusty@rustcorp.com.au> <20080204222457.286b962f.akpm@linux-foundation.org>
In-Reply-To: <20080204222457.286b962f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060948.11133.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 17:24:57 Andrew Morton wrote:
> On Tue, 5 Feb 2008 17:08:37 +1100 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > On Tuesday 05 February 2008 14:53:18 Andrew Morton wrote:
> > > That risks killing previously-working setups.  WARN_ON is sufficient.
> >
> > I disagree.  WARN_ON is useful for developers, but they can handle
> > BUG_ON, too.
>
> For developers, BUG_ON has zero benefit relative to WARN_ON.
>
> For non-developers, BUG_ON has large disadvantages relative to WARN_ON.
>
> It's a no-brainer.

For non-developers, WARN_ON is a noop.

For developers, WARN_ON is often a noop.

BUG_ON() will make us fix it in return for short-term pain.  WARN_ON() wont, 
in return for less pain.  It's mildly better than nothing, but not worth the 
patch.

Rusty.
