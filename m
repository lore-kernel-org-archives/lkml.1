Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYBEGZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYBEGZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYBEGZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:25:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYBEGZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:25:24 -0500
Date: Mon, 4 Feb 2008 22:24:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Whine about suspicious return values from module's
 ->init() hook
Message-Id: <20080204222457.286b962f.akpm@linux-foundation.org>
In-Reply-To: <200802051708.37349.rusty@rustcorp.com.au>
References: <20080204154215.GA26618@localhost.sw.ru>
	<200802051443.31783.rusty@rustcorp.com.au>
	<20080204195318.bf653285.akpm@linux-foundation.org>
	<200802051708.37349.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008 17:08:37 +1100 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 05 February 2008 14:53:18 Andrew Morton wrote:
> > On Tue, 5 Feb 2008 14:43:31 +1100 Rusty Russell <rusty@rustcorp.com.au> 
> wrote:
> > > On Tuesday 05 February 2008 02:42:15 Alexey Dobriyan wrote:
> > > > One head-scratching session could be noticeably shorter with this
> > > > patch...
> > > >
> > > > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> > >
> > > If we want to prevent > 0 returns, let's just BUG_ON().
> >
> > That risks killing previously-working setups.  WARN_ON is sufficient.
> 
> I disagree.  WARN_ON is useful for developers, but they can handle BUG_ON, 
> too.

For developers, BUG_ON has zero benefit relative to WARN_ON.

For non-developers, BUG_ON has large disadvantages relative to WARN_ON.

It's a no-brainer.
