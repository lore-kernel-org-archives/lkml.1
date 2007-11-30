Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbXK3SYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbXK3SYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbXK3SYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:24:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35824 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756713AbXK3SYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:24:03 -0500
Date: Fri, 30 Nov 2007 10:24:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/3] Per cpu relocation to ZERO and x86_32 percpu ops on
 x86_64
In-Reply-To: <20071130180002.GB19571@elte.hu>
Message-ID: <Pine.LNX.4.64.0711301019590.1743@schroedinger.engr.sgi.com>
References: <20071130064305.459255715@sgi.com> <20071130112429.GA3605@elte.hu>
 <20071130112645.GA7565@elte.hu> <Pine.LNX.4.64.0711300918250.32294@schroedinger.engr.sgi.com>
 <20071130180002.GB19571@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> you mean this single patch:
> 
>  modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
> 
> that's the only patch i missed AFAICS.

That is a pretty uncritical one. Then there is the fix of the zero address 
handling in modules.c, the fixup for the use of __per_cpu_xx variables in 
modules.c. etc.

It would be best to test against mm since there are core changes here that 
will have to wait to the next merge period.

