Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXKTCRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXKTCRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762336AbXKTCM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:12:28 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40000 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762201AbXKTCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:12:26 -0500
Date: Mon, 19 Nov 2007 18:12:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data handling
 on x86_64
In-Reply-To: <20071119.181016.224103721.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711191811290.20625@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071119.175116.55102316.davem@davemloft.net>
 <Pine.LNX.4.64.0711191758390.19954@schroedinger.engr.sgi.com>
 <20071119.181016.224103721.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Mon, 19 Nov 2007 17:59:33 -0800 (PST)
> 
> > In that case the generic fallbacks can just provide what you already
> > have.
> 
> I understand, I was just letting you know why we probably won't
> take advantage of this new stuff :-)

On the other hand: The pointer array removal and the allocation 
density improvements of the cpu_alloc should also help sparc to 
increase the information density in cachelines and thus increase overall 
speed of your 64p box.

