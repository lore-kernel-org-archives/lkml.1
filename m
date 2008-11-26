Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYKZGFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYKZGFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYKZGFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:05:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:49182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYKZGFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:05:31 -0500
Date: Tue, 25 Nov 2008 22:06:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] random: add a way to get some random bits into the
 entropy pools early on
Message-ID: <20081125220627.4a07f6b7@infradead.org>
In-Reply-To: <1227649282.3196.3.camel@calx>
References: <20081125132600.5112fb24@infradead.org>
	<1227649282.3196.3.camel@calx>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 15:41:22 -0600
Matt Mackall <mpm@selenic.com> wrote:


> > 
> > This patch adds a function to the random driver so that various
> > pieces of the kernel can add random bits (but not entropy!) to the
> > pool, to avoid this dupicate ID problem.
> 
> This appears to be equivalent to making random initialize earlier,
> except with more code?

well sort of kinda, but arbitrarily early (eg I made the oops ID just
call this whenever it's called first)

> 
> If we're going down a route like this, I'd like to see the ability to
> actually mix in data (ie MAC addresses, DMI data, etc.) rather than
> just timing.

I'll make a second patch for that; it does make sense to do this,
but it also makes sense to just have a "just do the time" helper



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
