Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXDQHbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXDQHbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXDQHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:31:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:19225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXDQHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HZ9v2UYQ3gmHYpHh5QIiX75ewr2IzxY8/sIw5A5pbt5+6SbuIk6t6CN2rGkSuPQ+iTQRTa6bTGJzeWYisa+9gz/CGUmdYA0IagA1XeRBwhupw0yyBJBWOcdce8czD4YnXEOEL917xrgzU8wpTxhhC75+RG9KWc7qs/ue7ifOkHA=
Message-ID: <84144f020704170031h9421d05t2174639ac8f2d894@mail.gmail.com>
Date: Tue, 17 Apr 2007 10:31:06 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
Cc: akpm@linux-foundation.com, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704162232530.31027@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704162232530.31027@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: a80ea1e6cab9a368
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Christoph Lameter <clameter@sgi.com> wrote:
> The flag SLAB_MUST_HWCACHE_ALIGN is
>
> 1. Never checked by SLAB at all.
>
> 2. A duplicate of SLAB_HWCACHE_ALIGN for SLUB
>
> 3. Fulfills the role of SLAB_HWCACHE_ALIGN for SLOB.
>
> The only remaining use is in sparc64 and ppc64 and their use there
> reflects some earlier role that the slab flag once may have had. If
> its specified then SLAB_HWCACHE_ALIGN is also specified.
>
> The flag is confusing, inconsistent and has no purpose.
>
> Remove it.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
