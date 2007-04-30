Return-Path: <linux-kernel-owner+w=401wt.eu-S1031563AbXD3Rnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031563AbXD3Rnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031574AbXD3Rnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:43:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32826 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031563AbXD3Rnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:43:31 -0400
Date: Mon, 30 Apr 2007 10:43:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Please revert [PATCH] user of the jiffies rounding patch: Slab
In-Reply-To: <1177803630.3477.3.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0704301042580.6343@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704281403140.12122@schroedinger.engr.sgi.com> 
 <4633D1A2.6010002@linux.intel.com>  <Pine.LNX.4.64.0704281632001.12695@schroedinger.engr.sgi.com>
 <1177803630.3477.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Arjan van de Ven wrote:

> > Hmmm... Yes but that looks like it comes from a different function. Slab
> > calls
> > 
> >  __round_jiffies_relative(HZ, cpu))
> > 
> > And its description says:
> > 
> > /**
> >  *
> >  * The exact rounding is skewed for each processor to avoid all
> >  * processors firing at the exact same time, which could lead
> >  * to lock contention or spurious cache line bouncing.
> 
> 
> > This is exactly the wrong thing to do.
> 
> 
> is it?

Umm you did not read the last bit of the description? It talks about 
firing all timers on all cpus at once.
 
