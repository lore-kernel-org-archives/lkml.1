Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXFBEBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXFBEBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXFBEBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:01:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbXFBEBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:01:10 -0400
Date: Fri, 1 Jun 2007 21:01:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <20070601204141.f84ad72f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <20070601204141.f84ad72f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Andrew Morton wrote:

> > On Fri, 1 Jun 2007 18:37:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> >
> > +#define ZERO_SIZE_PTR ((void *)16)
> 
> Jeremy's point was a good one.  The kernel _does_ use address-comparison
> to determine object-inequality in an unknown but non-zero number of places.
> 
> It is of course unlikely that this will occur in conjunction with zero-sized
> objects, but who knows?

The zero sized objects are always the same and have the same content of 
nothingness. So the kernel would find that they are the same which they 
indeed are. Why could this be a problem?
