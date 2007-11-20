Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbXKTVfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbXKTVfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbXKTVez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:34:55 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40687 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760375AbXKTVey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:34:54 -0500
Date: Tue, 20 Nov 2007 13:34:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <47434C46.5080301@zytor.com>
Message-ID: <Pine.LNX.4.64.0711201334170.27539@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de>
 <474346DE.5050305@zytor.com> <200711202151.58310.ak@suse.de>
 <Pine.LNX.4.64.0711201257580.27235@schroedinger.engr.sgi.com>
 <47434C46.5080301@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, H. Peter Anvin wrote:

> But you wouldn't actually *use* this address space.  It's just for the linker
> to know what address to tag the references with; it gets relocated by gs_base
> down into proper kernel space.  The linker can stash the initialized reference
> copy at any address (LMA) which can be different from what it will be used at
> (VMA); that is not an issue.

That is already provided by this patchset. The cpu area starts at absolute 
0.
 
> To use %rip references, though, which are more efficient, you probably want to
> use offsets that are just below .text (at -2 GB); presumably
> -2 GB-[max size of percpu section].  Again, however, no CPU actually needs to
> have its data stashed in that particular location; it's just an offset.

Right. That is what we are discussion in another thread.

