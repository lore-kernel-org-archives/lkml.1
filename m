Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbXFSWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbXFSWcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXFSWcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:32:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45241 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753345AbXFSWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:32:06 -0400
Date: Tue, 19 Jun 2007 15:32:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
Subject: Re: [patch 11/26] SLUB: Add support for kmem_cache_ops
In-Reply-To: <84144f020706191358j1992dd50ga5d93efbd61878d6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706191531330.7633@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>  <20070618095916.083793990@sgi.com>
 <84144f020706191358j1992dd50ga5d93efbd61878d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Pekka Enberg wrote:

> On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> > We use the parameter formerly used by the destructor to pass an optional
> > pointer to a kmem_cache_ops structure to kmem_cache_create.
> > 
> > kmem_cache_ops is created as empty. Later patches populate kmem_cache_ops.
> 
> I like kmem_cache_ops but I don't like this patch. I know its painful
> but we really want the introduction patch to fixup the API (move ctor
> to kmem_cache_ops and do the callers).

That can be done later. The effort does not increase because of this 
patch. If you have the time please do such a patch.

 
