Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab0AOXjI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660Ab0AOXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:38:57 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:57991 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758681Ab0AOXiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:38:54 -0500
Date: Fri, 15 Jan 2010 17:38:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: remove impossible condition
In-Reply-To: <alpine.DEB.2.00.1001151249040.11990@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1001151736110.10558@router.home>
References: <alpine.DEB.2.00.1001151249040.11990@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, David Rientjes wrote:

> `s' cannot be NULL if kmalloc_caches is not NULL.
>
> This conditional would trigger a NULL pointer on `s', anyway, since it is
> immediately derefernced if true.

Ok that was caused by the patches for the dma kmalloc in the -next tree.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

