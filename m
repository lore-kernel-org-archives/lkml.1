Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbXHVALx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbXHVALx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXHVALp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:11:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35204 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbXHVALp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:11:45 -0400
Date: Tue, 21 Aug 2007 17:11:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822000323.GG29691@Krystal>
Message-ID: <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com>
References: <20070820215413.GA28452@Krystal>
 <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com>
 <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
 <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:

> - Rounding error.. you seem to round at 0.1ms, but I keep the values in
>   cycles. The times that you get (1.1ms) seems strangely higher than
>   mine, which are under 1000 cycles on a 3GHz system (less than 333ns).
>   I guess there is both a ms - ns error there and/or not enough
>   precision in your numbers.

Nope the rounding for output is depending on the amount. Rounds to one 
digit after whatever unit we figured out is best to display.

And multiplications (cyc2ns) do not result in rounding errors.

