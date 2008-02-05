Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYBEGI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYBEGI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYBEGIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:08:50 -0500
Received: from ozlabs.org ([203.10.76.45]:47632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbYBEGIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:08:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Whine about suspicious return values from module's ->init() hook
Date: Tue, 5 Feb 2008 17:08:37 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
References: <20080204154215.GA26618@localhost.sw.ru> <200802051443.31783.rusty@rustcorp.com.au> <20080204195318.bf653285.akpm@linux-foundation.org>
In-Reply-To: <20080204195318.bf653285.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051708.37349.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 14:53:18 Andrew Morton wrote:
> On Tue, 5 Feb 2008 14:43:31 +1100 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > On Tuesday 05 February 2008 02:42:15 Alexey Dobriyan wrote:
> > > One head-scratching session could be noticeably shorter with this
> > > patch...
> > >
> > > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> >
> > If we want to prevent > 0 returns, let's just BUG_ON().
>
> That risks killing previously-working setups.  WARN_ON is sufficient.

I disagree.  WARN_ON is useful for developers, but they can handle BUG_ON, 
too.

If we were in freeze, I'd say WARN_ON.

Even better, audit them all, then BUG_ON.  Alexey?
Rusty.
