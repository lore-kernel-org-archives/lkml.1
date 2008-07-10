Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYGJPYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYGJPYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYGJPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:24:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYGJPY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:24:27 -0400
Date: Thu, 10 Jul 2008 11:23:41 -0400
From: Alan Cox <alan@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Miquel van Smoorenburg <miquels@cistron.nl>, akpm@linux-foundation.org,
       alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Message-ID: <20080710152341.GG15464@devserv.devel.redhat.com>
References: <20080710121350.52d854c7@the-village.bc.nu> <E1KGa1W-0004nG-Cw@n2o.xs4all.nl> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <4561.1215612914@redhat.com> <20080709164929.799e4e05@the-village.bc.nu> <1215630402.18506.10.camel@localhost.localdomain> <27706.1215691933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27706.1215691933@redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:12:13PM +0100, David Howells wrote:
> 
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > -static inline int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr,
> > -				size_t len, gfp_t gfp_mask)
> > ...
> > +extern int i2o_dma_alloc(struct device *dev, struct i2o_dma *addr, size_t len);
> 
> But where is it now?  Have you forgotten to attach a new file?  i2o/memory.c
> perhaps?

Yes.. hold on a moment 8)
