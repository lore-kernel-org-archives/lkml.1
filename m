Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbXFRUIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbXFRUIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763117AbXFRUIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:08:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:6020 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763600AbXFRUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WtEWWfrcjVz9nGMSM1Awrv4TXy/fZRfKk4L/TofYJMrjQJtXD5t6ItCyBRVnqmdREBr2V8JIjWt7SFN7d/q1GQwsYfDquv24WCBvBJQugVncHy/wjIi5tTNdrZvByejsJvGhQfDgZwTopWiF2gV3J9KuLQd79M/GcemlwR2j6qY=
Message-ID: <84144f020706181308v689254dl80a5dd42ba6014c4@mail.gmail.com>
Date: Mon, 18 Jun 2007 23:08:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 03/26] Slab allocators: Consistent ZERO_SIZE_PTR support and NULL result semantics
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <20070618095914.097484951@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095914.097484951@sgi.com>
X-Google-Sender-Auth: 8a52f0646e91e20b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> Define ZERO_OR_NULL_PTR macro to be able to remove the checks
> from the allocators. Move ZERO_SIZE_PTR related stuff into slab.h.
>
> Make ZERO_SIZE_PTR work for all slab allocators and get rid of the
> WARN_ON_ONCE(size == 0) that is still remaining in SLAB.
>
> Make slub return NULL like the other allocators if a too large
> memory segment is requested via __kmalloc.

Looks good to me.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
