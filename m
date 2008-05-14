Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbYENRoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbYENRoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYENRoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:44:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51327 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757912AbYENRoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:44:05 -0400
Date: Wed, 14 May 2008 10:44:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benny Halevy <bhalevy@panasas.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLUB: clear c->freelist in __slab_alloc()/load_freelist:/SlabDebug
 path
In-Reply-To: <4829ED5C.6080503@panasas.com>
Message-ID: <Pine.LNX.4.64.0805141043200.15374@schroedinger.engr.sgi.com>
References: <4828A940.2090604@panasas.com> <84144f020805131140s233090e5v4f77c4853a91f2ec@mail.gmail.com>
 <4829ED5C.6080503@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008, Benny Halevy wrote:

> > But for debug pages, we never load c->page->freelist to c->freelist so
> > it should always be NULL.
> 
> Hmm, I see.  Then it might have got corrupted...
> I'll keep looking for the root cause.

Correct.

> > How did you make SLUB hit the debug path since you have
> > CONFIG_SLUB_DEBUG_ON disabled?

I guess he passed slub_debug on the kernel command line.

