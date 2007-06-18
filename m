Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbXFRUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbXFRUMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762514AbXFRUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:12:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:8276 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761420AbXFRUMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oCCsqpygoB4ClXpjroS7Ni0nnWOpT3aCM/4Hih/duqowRPy+sAodBSK04sCGQfAmwYmYMd25EGkzCKN+NzCQ+Z+hX0CQHrrMAFxk5CTolmu9ZQ4TP6MYhftW1T0ogMU8EkpYLuxXGvSkx9aVD7yxlp84AGwVesaVHs45YBiUtE8=
Message-ID: <84144f020706181311u2bb10658i3869f7aeb8e29f8e@mail.gmail.com>
Date: Mon, 18 Jun 2007 23:11:59 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 04/26] Slab allocators: Support __GFP_ZERO in all allocators.
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <20070618095914.332369986@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095914.332369986@sgi.com>
X-Google-Sender-Auth: dca86d43a423246f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> A kernel convention for many allocators is that if __GFP_ZERO is passed to
> an allocator then the allocated memory should be zeroed.
>
> This is currently not supported by the slab allocators. The inconsistency
> makes it difficult to implement in derived allocators such as in the uncached
> allocator and the pool allocators.

[snip]

> So add the necessary logic to all slab allocators to support __GFP_ZERO.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
