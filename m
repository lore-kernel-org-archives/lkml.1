Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZA1IwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZA1IwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZA1IwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:52:15 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40844 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZA1IwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:52:15 -0500
Subject: Re: [patch] slub: fix per cpu kmem_cache_cpu array memory leak
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0901271859010.17612@chino.kir.corp.google.com>
Date: Wed, 28 Jan 2009 10:52:12 +0200
Message-Id: <1233132733.16201.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 18:59 -0800, David Rientjes wrote:
> The per cpu array of kmem_cache_cpu structures accomodates
> NR_KMEM_CACHE_CPU such structs.
> 
> When this array overflows and a struct is allocated by kmalloc(), it may
> have an address at the upper bound of this array.  If this happens, it
> does not get freed and the per cpu kmem_cache_cpu_free pointer will be out
> of bounds after kmem_cache_destroy() or cpu offlining.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!

