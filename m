Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbYEWO1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbYEWO1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYEWO0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:26:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60491 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbYEWO0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:26:06 -0400
Date: Fri, 23 May 2008 17:23:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, Paul Mundt <lethal@linux-sh.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
Message-ID: <20080523142341.GA28257@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi> <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com> <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org> <4834F9D6.7080706@cs.helsinki.fi> <1211468502.18026.350.camel@calx> <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:13:56PM +0300, Pekka Enberg wrote:
>...
> However, I think we should just look at getting rid of ksize()
> altogether as it's only (ab)used by the nommu code and few call-sites
> that open-code krealloc().

As soon as your patch for the netfilter usage enters Linus' tree you can 
unexport it which will at least make new abuses from modules impossible.

>                        Pekka

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

