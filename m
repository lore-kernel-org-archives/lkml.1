Return-Path: <linux-kernel-owner+w=401wt.eu-S1764985AbXHFUNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764985AbXHFUNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbXHFUMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:12:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33226 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756251AbXHFUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:12:48 -0400
Date: Mon, 6 Aug 2007 13:12:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <1186428690.11797.96.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708061312330.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>  <20070806103658.107883000@chello.nl>
  <Pine.LNX.4.64.0708061108430.25069@schroedinger.engr.sgi.com> 
 <200708061121.50351.phillips@phunq.net> <1186425063.11797.80.camel@lappy> 
 <Pine.LNX.4.64.0708061209230.7603@schroedinger.engr.sgi.com>
 <1186428690.11797.96.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Peter Zijlstra wrote:

> The functionality this is aimed at is swap over network, and I doubt
> you'll be enabling that on these machines.

So add #ifdefs around it?

