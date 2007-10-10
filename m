Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXJJVJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXJJVJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 17:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbXJJVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 17:09:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40338 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755577AbXJJVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 17:09:28 -0400
Date: Wed, 10 Oct 2007 14:09:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <ak@suse.de>, William Lee Irwin III <wli@holomorphy.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386:  remove dead code in pgtable_cache_init
In-Reply-To: <470D3846.1000209@goop.org>
Message-ID: <Pine.LNX.4.64.0710101407560.32488@schroedinger.engr.sgi.com>
References: <470D3846.1000209@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Jeremy Fitzhardinge wrote:

> The conversion from using a slab cache to quicklist left some residual dead code.
> 
> I note that in the conversion it now always allocates a whole page for
> the pgd, rather than the 32 bytes needed for a PAE pgd.  Was this
> intended?

I believe that virtualization support needed a full pgd.
