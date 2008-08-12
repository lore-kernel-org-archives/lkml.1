Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbYHLMeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbYHLMeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYHLMdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:33:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYHLMdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:33:52 -0400
Subject: Re: [RFC/PATCH] SLUB: dynamic per-cache MIN_PARTIAL
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, cl@linux-foundation.org
In-Reply-To: <20080812122751.GY8618@parisc-linux.org>
References: <Pine.LNX.4.64.0808050037400.26319@sbz-30.cs.Helsinki.FI>
	 <20080812122751.GY8618@parisc-linux.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Aug 2008 15:33:53 +0300
Message-Id: <1218544433.7813.301.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Tue, Aug 05, 2008 at 12:39:36AM +0300, Pekka J Enberg wrote:
> > This patch changes the static MIN_PARTIAL to a dynamic per-cache ->min_partial
> > value that is calculated from object size. The bigger the object size, the more
> > pages we keep on the partial list.
> > 
> > I tested SLAB, SLUB, and SLUB with this patch on Jens Axboe's 'netio' example
> > script of the fio benchmarking tool. The script stresses the networking
> > subsystem which should also give a fairly good beating of kmalloc() et al.

﻿On Tue, 2008-08-12 at 06:27 -0600, Matthew Wilcox wrote:
> We tested this patch and it was performance-neutral on TPC-C.  I was
> hoping it would give a nice improvement ... so I'm disappointed.  But at
> least there's no regression!

OK, so your regression is something else then. Well, thanks for testing!

