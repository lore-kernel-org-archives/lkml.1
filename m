Return-Path: <linux-kernel-owner+w=401wt.eu-S967638AbXG3SF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967638AbXG3SF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966811AbXG3SFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:05:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41617 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966676AbXG3SFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:05:10 -0400
Date: Mon, 30 Jul 2007 11:05:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robert Schwebel <r.schwebel@pengutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: bug in slab.c
In-Reply-To: <20070730180301.GG1678@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0707301103580.743@schroedinger.engr.sgi.com>
References: <20070729073739.GD1678@pengutronix.de>
 <20070730001604.d58dca0a.akpm@linux-foundation.org> <20070730180301.GG1678@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007, Robert Schwebel wrote:

> On Mon, Jul 30, 2007 at 12:16:04AM -0700, Andrew Morton wrote:
> > > My Dell Latitude D520 just dies with this BUG:
> >
> > Reproducible, I assume.
> 
> No, happened only one time.

Looks like the slab header was corrupted. If this can be reproduced then 
you need to enable slub debugging to find the kernel function that 
corrupts memory.

Otherwise it could be bad memory?

