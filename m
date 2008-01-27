Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYA0V4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYA0V4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYA0V4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:56:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:5492 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYA0V4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:56:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FKz6YMcrM85ilSw3+eBzu29vr7WkSpXNH6CdHh1Hp3+RQPUdrznE/A6qx5HxWRDeoPTR6JZwP/LHEyttFzD08DelIy35D2YA1n/nsyrn5zZDekHSj2YRoL2nMHrYKWPtULtng3zbEL4K7XqcBflkPsFYG2eXqGMzhB68ckhxsLY=
Message-ID: <19f34abd0801271356v4567f6dfie966ccefd7454c72@mail.gmail.com>
Date: Sun, 27 Jan 2008 22:56:41 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: lib/idr.c: initialize struct idr_layer
Cc: "Jim Houston" <jim.houston@ccur.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020801271335v4f2491a2n18b12de2ef245499@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
	 <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
	 <19f34abd0801271317o4b17dc28l3c93d4d28e3e2e73@mail.gmail.com>
	 <Pine.LNX.4.64.0801272319570.540@sbz-30.cs.Helsinki.FI>
	 <19f34abd0801271330j596cd9fbqbd3691548dff26@mail.gmail.com>
	 <84144f020801271335v4f2491a2n18b12de2ef245499@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 10:35 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > I think there's a pretty big chance I'm wrong (or misunderstanding
> > something) here, so I'll just ask:
> > setup_object() from mm/slub.c is what calls the ctor. Shouldn't this
> > be called from slab_alloc() as well? (I'm marking the data
> > "uninitialized" there before returning the object.) Otherwise you
> > might get back an object that is initialized with the previous owner's
> > data. Or is this intentional?
>
> It's intentional. The caller of kmem_cache_free() is expected to put
> the object in such a state that it can be recycled immediately when
> kmem_cache_alloc() for that cache is called. You can find the design
> rationale for that in Bonwick's original paper on slab:
> http://citeseer.ist.psu.edu/bonwick94slab.html

Ow. I guess this is the end of the thread, then :-) My fault. Thanks!

Vegard
