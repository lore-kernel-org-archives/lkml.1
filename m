Return-Path: <linux-kernel-owner+w=401wt.eu-S1763912AbXHTUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763912AbXHTUr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbXHTUq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:46:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47520 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753299AbXHTUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:46:56 -0400
Date: Mon, 20 Aug 2007 13:46:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
In-Reply-To: <20070820204126.GA22507@Krystal>
Message-ID: <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:

> Yes, I use it as synchronization mechanism for my buffer management algorithm
> in LTTng. Since I write in per-cpu buffers and want to be as reentrant
> as possible wrt other contexts (dealing with NMI as worse case, but also
> applies to MCE..), I use local_cmpxchg to reserve space in my buffers.
> It is faster than the standard cmpxchg.

Ok I have seen these numbers in the OLS papers but I could not reproduce 
them in SLUB.

