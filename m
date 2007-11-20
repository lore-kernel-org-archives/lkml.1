Return-Path: <linux-kernel-owner+w=401wt.eu-S1764417AbXKTU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764417AbXKTU65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762950AbXKTU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:58:39 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57147 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762864AbXKTU6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:58:38 -0500
Date: Tue, 20 Nov 2007 12:58:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <200711202151.58310.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711201257580.27235@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de>
 <474346DE.5050305@zytor.com> <200711202151.58310.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Andi Kleen wrote:

> 
> > This limitation shouldn't apply to the percpu area, since gs_base can be 
> > pointed anywhere in the address space -- in effect we're always indirect.
> 
> The initial reference copy of the percpu area has to be addressed by
> the linker.

Right that is important for the percpu references that can be folded by 
the linker in order to avoid address calculations.

> Hmm, in theory since it is not actually used by itself I suppose you could 
> move it into positive space.

But the positive space is reserved for a processes memory.

