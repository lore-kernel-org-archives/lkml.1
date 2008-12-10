Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYLJU1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYLJU1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYLJU1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:27:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:1571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbYLJU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:27:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yIPLT7h+RUFZDrgRq5jB8qn9ZJb+icI6znwPntJDeDwnswci8r5LaDmo/gpUpS8qIi
         ClsUEyBtt/FeTw6XeaTWCVxGUGbJ9p1VScV4aInQaE5IUCovTiQSLZVmpwgXnhFHC0Uq
         kGlaE3c2IxwfTnXKZx9V00KGuaoWBWUAWX8I8=
Date: Wed, 10 Dec 2008 23:23:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob
	kmem_cache_create
Message-ID: <20081210202355.GC2215@localhost>
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com> <20081210193421.GA2215@localhost> <Pine.LNX.4.64.0812101411020.15262@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812101411020.15262@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Dec 10, 2008 at 02:11:23PM -0600]
| On Wed, 10 Dec 2008, Cyrill Gorcunov wrote:
| 
| > this would make the following line in slob_alloc
| >
| > 	...
| > 	if (unlikely((gfp & __GFP_ZERO) && b))
| > 		memset(b, 0, size);
| >  	...
| >
| > useless. Not sure if it will be good :)
| 
| No. GFP_ZERO is set when kmalloc etc is called. Its not set on
| kmem_cache_create.
| 

yep, Matt already pointed, I just missed first time.

		- Cyrill -
