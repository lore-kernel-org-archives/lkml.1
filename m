Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbXHTStl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbXHTStl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbXHTStc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:49:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2138 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbXHTStb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:49:31 -0400
Subject: Re: [PATCH 5/5] mm/... convert #include "linux/..." to #include
	<linux/...>
From: Joe Perches <joe@perches.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0708201106230.25248@schroedinger.engr.sgi.com>
References: <1187561983.4200.145.camel@localhost>
	 <Pine.LNX.4.64.0708201106230.25248@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 11:49:26 -0700
Message-Id: <1187635766.5963.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 11:06 -0700, Christoph Lameter wrote:
> On Sun, 19 Aug 2007, Joe Perches wrote:
> > diff --git a/mm/slab.c b/mm/slab.c
> > -#include "linux/kmalloc_sizes.h"
> > +#include <linux/kmalloc_sizes.h>
> But I think this was done intentionally to point out that the file 
> includes is *not* a regular include file.

Maybe.  I think it's just a simple error.

mm/slab.c has 2 other includes of

	#include <linux/kmalloc_sizes.h>

cheers, Joe

