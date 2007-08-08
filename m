Return-Path: <linux-kernel-owner+w=401wt.eu-S938316AbXHHSxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938316AbXHHSxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbXHHSww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:52:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760649AbXHHSwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:52:51 -0400
Date: Wed, 8 Aug 2007 11:46:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
Message-Id: <20070808114636.7c6f26ab.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708081050590.12652@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	<20070806103658.603735000@chello.nl>
	<Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
	<20070808014435.GG30556@waste.org>
	<Pine.LNX.4.64.0708081004290.12652@schroedinger.engr.sgi.com>
	<20070808103946.4cece16c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708081050590.12652@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 10:57:13 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> I think in general irq context reclaim is doable. Cannot see obvious 
> issues on a first superficial pass through rmap.c. The irq holdoff would 
> be pretty long though which may make it unacceptable.

The IRQ holdoff could be tremendous.  But if it is sufficiently infrequent
and if the worst effect is merely a network rx ring overflow then the tradeoff
might be a good one.
