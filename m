Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbZAUI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbZAUI3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZAUI3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:29:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:51325 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754608AbZAUI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:29:38 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19+l9kIj51+w9NhgIAmsupI4o2nKy9+/daOfFAurQ
	yafvP5XuW2zaSD
Date: Wed, 21 Jan 2009 09:29:39 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Paul Mundt <lethal@linux-sh.org>
cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Adrian McMenamin <lkmladrian@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-sh <linux-sh@vger.kernel.org>, penberg@cs.helsinki.fi,
       dbaryshkov@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] dma: fix up broken comparison in dma_alloc_from_coherent
In-Reply-To: <20090121081118.GA14537@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0901210928010.4407@axis700.grange>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
 <1232488507.6794.8.camel@localhost.localdomain> <20090121033951.GB14094@linux-sh.org>
 <20090121081118.GA14537@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitpick:

On Wed, 21 Jan 2009, Paul Mundt wrote:

> +	/*
> +	 * Memory was found in the per-device arena.
> +	 */

s/arena/area/ ?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
