Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZC0RJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZC0RJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZC0RJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:09:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZC0RJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:09:06 -0400
Date: Fri, 27 Mar 2009 13:09:03 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: arnd@arndb.de
Cc: liqin.chen@sunplusct.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       monstr@monstr.eu, john.williams@petalogix.com
Subject: Re: [PATCH 7/13] score - New architecure port to SunplusCT S+CORE
	processor
Message-ID: <20090327170903.GC29999@bombadil.infradead.org>
References: <OF67FB031C.57858745-ON48257586.000915EE-48257586.00097F4B@sunplusct.com> <200903271705.29903.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903271705.29903.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 05:05:29PM +0100, arnd@arndb.de wrote:
> > +config MACH_SPCT6600
> > +       bool "SPCT6600 series based machines"
> > +       select SYS_SUPPORTS_32BIT_KERNEL
> > +       select SYS_SUPPORTS_LITTLE_ENDIAN
> > +       select CPU_SCORE7
> > +       select GENERIC_HAS_IOMAP
> > +

Huh, is it intended to add big endian support? <asm/byteorder.h>
was just including <asm-generic/little_endian.h> and should probably
be conditional on your SYS_SUPPROTS_BIG_ENDIAN if so...

I've dug a bit at your code for this, and can't see where you obviously
set a byte order bit in a control register... is it hard wired on the
board?

regards, Kyle
