Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbXGKBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbXGKBMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbXGKBMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:12:10 -0400
Received: from waste.org ([66.93.16.53]:52165 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbXGKBMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:12:09 -0400
Date: Tue, 10 Jul 2007 20:11:53 -0500
From: Matt Mackall <mpm@selenic.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check charset in scripts/checkpatch.pl
Message-ID: <20070711011153.GU11166@waste.org>
References: <1183705264.2747.20.camel@shinybook.infradead.org> <20070706000807.8f9f83ca.akpm@linux-foundation.org> <1183706391.2747.27.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183706391.2747.27.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 03:19:50AM -0400, David Woodhouse wrote:
> On Fri, 2007-07-06 at 00:08 -0700, Andrew Morton wrote:
> > On Fri, 06 Jul 2007 03:01:03 -0400 David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > Reject all legacy 8-bit character sets and allow only ASCII or UTF-8 to
> > > be added to files or used in patch descriptions.
> > 
> > What is the reasoning behind this?
> 
> The character set used by the kernel is UTF-8. So we should check for
> people trying to add invalid stuff in other character sets. There's no
> way for them to _label_ legacy character sets as such; it's not like
> MIME email where we can use a different charset for every mail and
> expect people to cope. We need to be consistent.

Seconded.

-- 
Mathematics is the supreme nostalgia of our time.
