Return-Path: <linux-kernel-owner+w=401wt.eu-S935763AbXK3RRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763AbXK3RRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760356AbXK3RRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:17:22 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48996 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756877AbXK3RRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:17:21 -0500
Date: Fri, 30 Nov 2007 09:17:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more "generic"
In-Reply-To: <20071130171419.GA18808@elte.hu>
Message-ID: <Pine.LNX.4.64.0711300915460.32253@schroedinger.engr.sgi.com>
References: <20071128210926.008783214@sgi.com> <20071128211526.640694725@sgi.com>
 <20071130111000.GA32431@elte.hu> <Pine.LNX.4.64.0711300908320.32071@schroedinger.engr.sgi.com>
 <20071130171419.GA18808@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Ingo Molnar wrote:

> > This is a core change against Andrew's tree. It needs to go into mm 
> > and not into the x86 tree. It is no surprise that this does not apply 
> > cleanly to the x86 tree.
> 
> well since they affect the x86 tree quite heavily (and a dependent 
> patchset you sent is basically for x86 only), it looked quite plausible 
> to check how they fare.

Yes that can be done by downloading 2.6.24-rc3-mm2 and 
applying the patches on top of it. There are various earlier cleanup 
patches in mm that fix various core issues that make all of this possible.

It would be great if you could review the patches and test them.



