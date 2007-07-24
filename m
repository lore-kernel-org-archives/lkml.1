Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbXGXDCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbXGXDCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXGXDCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:02:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49050 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750798AbXGXDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:02:36 -0400
Date: Mon, 23 Jul 2007 20:02:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: werner <werner@copaya.yi.org>, linux-kernel@vger.kernel.org
Subject: Re: Incompatibilities of kmem_cache_create
In-Reply-To: <20070721062032.GA1814@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0707232001090.1864@schroedinger.engr.sgi.com>
References: <1184997001.28478@werner> <20070721062032.GA1814@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Paul Mundt wrote:

> On Sat, Jul 21, 2007 at 02:50:01AM -0300, werner wrote:
> > Of the kernel 2.6.22-git15 of this night,  kmem_cache_create is not
> > compatible and causes compiling errors of some fundamental programs.
> > Before, this error didnt occur.
> > 
> Slab destructors haven't been supported in the kernel for ages, anything
> that's relying on them to work out-of-tree is fundamentally broken.

Slab destructors were supported and used in Linux kernels up to 
version 2.6.20. They were removed late in the 2.6.21 merge cycle.


