Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXGIVVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXGIVVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbXGIVVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:21:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55564 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755360AbXGIVVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:21:34 -0400
Date: Mon, 9 Jul 2007 14:21:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
In-Reply-To: <20070709.124359.38710002.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0707091419540.18102@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070707.213752.63129539.davem@davemloft.net>
 <Pine.LNX.4.64.0707090845230.13792@schroedinger.engr.sgi.com>
 <20070709.124359.38710002.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, David Miller wrote:

> As Andi seemed to imply I don't even think cmpxchg is faster than
> interrupt enable/disable on current generation AMD x86_64 chips, so
> are you targetting this optimization solely at Intel x86 Core Duo
> 32-bit chips?  That's the only one I can see which will benefit from
> this.  Are you going to probe the cpu sub-type and patch SLUB?

Not sure. The numbers I have seen in the papers indicate a potential 
speedup by a factor of 10 on x86 hardware. I have not done any 
benchmarking myself yet.

> Please reconsider this change, thanks.

This is an RFC after all so nothing is fixed yet. Certainly I will keep 
this in mind.
