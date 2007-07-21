Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbXGUXnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbXGUXnD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 19:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXGUXmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 19:42:53 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:38575 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXGUXmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 19:42:52 -0400
Date: Sun, 22 Jul 2007 08:42:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] mm: Remove slab destructors from kmem_cache_create().
Message-ID: <20070721234227.GA8303@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Matt Mackall <mpm@selenic.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <20070720012846.GA22487@linux-sh.org> <20070721212851.GH11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721212851.GH11166@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 04:28:52PM -0500, Matt Mackall wrote:
> On Fri, Jul 20, 2007 at 10:28:46AM +0900, Paul Mundt wrote:
> > Slab destructors were no longer supported after Christoph's
> > c59def9f222d44bb7e2f0a559f2906191a0862d7 change. They've been
> > BUGs for both slab and slub, and slob never supported them
> > either.
> 
> SLOB of course did support destructors, otherwise it wouldn't have
> worked.
> 
Ah, I just noticed that there was no reference to the dtor in SLOB at all
apart from the kmem_cache_create() op. It looks like they were called
back in to and removed by an earlier patch, so the 'never' statement is
disinformation on my part. Sorry for the confusion!
