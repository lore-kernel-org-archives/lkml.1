Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYBFGzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYBFGzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYBFGzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:55:36 -0500
Received: from ozlabs.org ([203.10.76.45]:50266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbYBFGzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:55:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Whine about suspicious return values from module's ->init() hook
Date: Wed, 6 Feb 2008 17:55:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: adobriyan@sw.ru, linux-kernel@vger.kernel.org
References: <20080204154215.GA26618@localhost.sw.ru> <200802060948.11133.rusty@rustcorp.com.au> <20080205153752.243d3b63.akpm@linux-foundation.org>
In-Reply-To: <20080205153752.243d3b63.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061755.27057.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008 10:37:52 Andrew Morton wrote:
> On Wed, 6 Feb 2008 09:48:10 +1100
>
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > It's a no-brainer.
> >
> > For non-developers, WARN_ON is a noop.
>
> Oh..  Rusty.  The mailing list and bugzilla are *full* of WARN_ON reports
> from testers.  Your statement is empirically wrong.

My apologies.  I had extrapolated from my own behaviour: I don't notice 
WARN_ON unless something else goes wrong to make me look in the logs.

> > BUG_ON() will make us fix it in return for short-term pain.
>
> Pain to our users and testers.  People upon whom we are very dependent and
> to whom we are hugely indebted.  People who I have to spend a lot of time
> defending from the likes of you!

I think you misunderstand.  I proposed that we audit all the code before such 
a change.  We shouldn't do *anything* until we can estimate the impact this 
change will have.

Our users deserve better than "I don't know if this will break anything so I 
used WARN_ON".  They deserve "we have confidence that this change won't break 
any existing code".

Now, if an audit is impractical or unreliable, we are better off with a 
WARN_ON.  But it is still an admission of ignorance.

Cheers,
Rusty.
