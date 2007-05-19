Return-Path: <linux-kernel-owner+w=401wt.eu-S1764473AbXESSTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764473AbXESSTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764144AbXESSTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:19:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55791 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758373AbXESSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:19:33 -0400
Date: Sat, 19 May 2007 11:19:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 01/10] SLUB: add support for kmem_cache_ops
In-Reply-To: <84144f020705190553s598e722fu7279253ee8b516bc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705191119010.17008@schroedinger.engr.sgi.com>
References: <20070518181040.465335396@sgi.com>  <20070518181118.828853654@sgi.com>
 <84144f020705190553s598e722fu7279253ee8b516bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Pekka Enberg wrote:

> On 5/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> > kmem_cache_ops is created as empty. Later patches populate kmem_cache_ops.
> 
> Hmm, would make more sense to me to move "ctor" in kmem_cache_ops in
> this patch and not make kmem_cache_create() take both as parameters...

Yeah earlier versions did this but then I have to do a patch that changes 
all destructors and all kmem_cache_create calls in the kernel.
 
