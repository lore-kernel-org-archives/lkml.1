Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbYARSnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbYARSnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762799AbYARSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:42:41 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47471 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759676AbYARSmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:42:39 -0500
Date: Fri, 18 Jan 2008 10:42:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Olaf Hering <olaf@aepfle.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080118065621.GA27495@aepfle.de>
Message-ID: <Pine.LNX.4.64.0801181042060.30348@schroedinger.engr.sgi.com>
References: <20080115150949.GA14089@aepfle.de>
 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de> <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
 <20080117211511.GA25320@aepfle.de> <20080118065621.GA27495@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Olaf Hering wrote:

> calls cache_grow with nodeid 0
> > [c00000000075bbd0] [c0000000000f82d0] .cache_alloc_refill+0x234/0x2c0
> calls cache_grow with nodeid 0
> > [c00000000075bbe0] [c0000000000f7f38] .____cache_alloc_node+0x17c/0x1e8
> 
> calls cache_grow with nodeid 1
> > [c00000000075bbe0] [c0000000000f7d68] .fallback_alloc+0x1a0/0x1f4

Hmmm... fallback_alloc should not be called during bootstrap.

