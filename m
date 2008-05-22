Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYEVERh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYEVERh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYEVER1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:17:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40644 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750712AbYEVER0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:17:26 -0400
Date: Wed, 21 May 2008 21:17:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
In-Reply-To: <4834F2E2.3070806@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
 <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Pekka Enberg wrote:

> Paul Mundt wrote:
> > This series seems to work ok with all of SLAB/SLUB/SLOB when also
> > applying the kobjsize() patch. Without the kobjsize() patch in place,
> > SLAB and SLUB both work, while SLOB still triggers the >= MAX_ORDER
> > BUG_ON() for page cache pages. Note that this is still an improvement
> > over SLUB blowing up, as it was before, even without the kobjsize()
> > change.
> 
> That's probably due to the fact that we use PageSlab for all pages with SLUB
> and for bigblock pages in SLOB with this patch. Christoph, Matt, any
> suggestions how to fix the PageSlab check in nommu btw?

I already posted a patch and commented numerous times. What else needs 
to be said? SLUB only uses PageSlab for kmalloc <=4kb.


