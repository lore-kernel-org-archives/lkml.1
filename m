Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYENRzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYENRzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYENRzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:55:04 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6670 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753452AbYENRzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:55:03 -0400
Message-ID: <482B2752.2090600@panasas.com>
Date: Wed, 14 May 2008 10:54:26 -0700
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLUB: clear c->freelist in __slab_alloc()/load_freelist:/SlabDebug
 path
References: <4828A940.2090604@panasas.com> <84144f020805131140s233090e5v4f77c4853a91f2ec@mail.gmail.com> <4829ED5C.6080503@panasas.com> <Pine.LNX.4.64.0805141043200.15374@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805141043200.15374@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2008 17:54:41.0865 (UTC) FILETIME=[96010390:01C8B5EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May. 14, 2008, 10:44 -0700, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 13 May 2008, Benny Halevy wrote:
> 
>>> But for debug pages, we never load c->page->freelist to c->freelist so
>>> it should always be NULL.
>> Hmm, I see.  Then it might have got corrupted...
>> I'll keep looking for the root cause.
> 
> Correct.

Yeah, I've moved to SLAB and the mem corruption now pops up at a different
place.

> 
>>> How did you make SLUB hit the debug path since you have
>>> CONFIG_SLUB_DEBUG_ON disabled?
> 
> I guess he passed slub_debug on the kernel command line.
> 

I did not.

I probably have misunderstood how the slub debugging infrastructure works
and did not execute the debug path at all.

Thanks for your help!

Benny
