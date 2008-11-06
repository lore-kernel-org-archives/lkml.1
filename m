Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbYKFQ2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbYKFQ2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYKFQ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:27:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:29551 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYKFQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ktaJbCXqEZ/n6y3NdavOKi3aWI4GbO7+h+IQQJPsYj34x39Qh8Y+qV70i23I8mzD+b
         Idmn1PQpUFZcWRL9p8qN5j/Psclfvh4xeO7JX/tLulzB9sCA6kb+v2r8qfp2tiuJtrb2
         9rFDU/nVA6ZUAQQ4v4MYMehs+GzaDe13DM0jU=
Date: Thu, 6 Nov 2008 19:31:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Broken "cpualloc: the allocator" patch
Message-ID: <20081106163107.GA3942@x200.localdomain>
References: <20081104034237.GA15227@x200.localdomain> <Pine.LNX.4.64.0811040934180.12886@quilx.com> <20081105084254.GA3429@x200.localdomain> <Pine.LNX.4.64.0811050741450.11741@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811050741450.11741@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 07:45:35AM -0600, Christoph Lameter wrote:
> --- linux-2.6.orig/include/linux/percpu.h
> +++ linux-2.6/include/linux/percpu.h
> @@ -44,11 +44,7 @@
>  extern unsigned int percpu_reserve;
>  /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
>  #ifndef PERCPU_AREA_SIZE
> -#ifdef CONFIG_MODULES
>  #define PERCPU_RESERVE_SIZE	8192
> -#else
> -#define PERCPU_RESERVE_SIZE	0
> -#endif

next-20081106 with this patch is fine, thank you.
