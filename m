Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXEQRaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXEQRaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757874AbXEQRaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:30:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52427 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757094AbXEQRaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:30:21 -0400
Date: Thu, 17 May 2007 10:30:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179386921.27354.29.camel@twins>
Message-ID: <Pine.LNX.4.64.0705171029500.17245@schroedinger.engr.sgi.com>
References: <1179350433.2912.66.camel@lappy> 
 <Pine.LNX.4.64.0705161435110.11642@schroedinger.engr.sgi.com>
 <1179386921.27354.29.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Peter Zijlstra wrote:

> > 2. It seems to be based on global ordering of allocations which is
> >    not possible given large systems and the relativistic constraints
> >    of physics. Ordering of events get more expensive the bigger the
> >    system is.
> > 
> >    How does this system work if you can just order events within
> >    a processor? Or within a node? Within a zone?
> 
> /me fails again..
> 
> Its about ensuring ALLOC_NO_WATERMARKS memory only reaches PF_MEMALLOC
> processes, not joe random's pi calculator.

Watermarks are per zone?
