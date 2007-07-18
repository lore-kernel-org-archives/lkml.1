Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXGRKsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXGRKsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 06:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXGRKsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 06:48:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56741 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753334AbXGRKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 06:48:34 -0400
Date: Wed, 18 Jul 2007 11:54:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Dave Airlie <airlied@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] vmalloc_32 should use GFP_KERNEL
Message-ID: <20070718115459.0cfe8ebc@the-village.bc.nu>
In-Reply-To: <1184741354.25235.222.camel@localhost.localdomain>
References: <1184739934.25235.220.camel@localhost.localdomain>
	<20070717233358.2edeaac0.akpm@linux-foundation.org>
	<1184741354.25235.222.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 16:49:14 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2007-07-17 at 23:33 -0700, Andrew Morton wrote:
> > whoops, yes.
> > 
> > Are those errors serious and common enough for 2.6.22.x?  
> 
> No idea, so far, the nouveau DRM isn't something I would recommend to
> people to use in stable environments but heh... I don't know who else
> uses vmalloc_32.

Mostly older video capture.

Alan
