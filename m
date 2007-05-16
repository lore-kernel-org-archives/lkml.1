Return-Path: <linux-kernel-owner+w=401wt.eu-S1761441AbXEPAvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbXEPAvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbXEPAvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:51:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41275 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760208AbXEPAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:51:14 -0400
Date: Tue, 15 May 2007 17:51:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, mroos@linux.ee,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
In-Reply-To: <20070515172957.02d80d51.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705151750450.4272@schroedinger.engr.sgi.com>
References: <20070515163321.744e2388.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
 <20070515165636.5057456e.akpm@linux-foundation.org>
 <20070515.171447.83623268.davem@davemloft.net> <20070515172957.02d80d51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, Andrew Morton wrote:

> > Try to define a compile-time array size with it smarty
> > pants :-)
> 
> confusedy pants, more like.
> 
> > That's what we did initially and it doesn't work.
> 
> This:
> 
> struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;
> 
> is still there.

This works fine. Please have a look at the RFC that gets rid of the mess.

