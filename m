Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbXKTCOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbXKTCOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760893AbXKTCCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:02:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39336 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759816AbXKTCCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:02:11 -0500
Date: Mon, 19 Nov 2007 18:02:11 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <474239CA.20403@zytor.com>
Message-ID: <Pine.LNX.4.64.0711191759370.19954@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011333.619991903@sgi.com>
 <474239CA.20403@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007, H. Peter Anvin wrote:

> You're making the assumption here that NUMA = large number of CPUs. This
> assumption is flat-out wrong.

Well maybe. Usually one gets to NUMA because the hardware gets too big to 
be handleed the UMA way.

> On x86-64, most two-socket systems are still NUMA, and I would expect that
> most distro kernels probably compile in NUMA.  However,
> burning megabytes of memory on a two-socket dual-core system when we're
> talking about tens of kilobytes used would be more than a wee bit insane.

Yeah yea but the latencies are minimal making the NUMA logic too expensive 
for most loads ... If you put a NUMA kernel onto those then performance 
drops (I think someone measures 15-30%?)

