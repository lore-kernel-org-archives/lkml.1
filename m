Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbXHWTZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbXHWTZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXHWTZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:25:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207AbXHWTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:25:05 -0400
Date: Thu, 23 Aug 2007 12:25:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] Per cpu structures for SLUB
In-Reply-To: <1187862724.6114.356.camel@twins>
Message-ID: <Pine.LNX.4.64.0708231223570.14478@schroedinger.engr.sgi.com>
References: <20070823064653.081843729@sgi.com> <1187862724.6114.356.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Peter Zijlstra wrote:

> while I like this patch set I'm at odds with the interaction of this and
> making the alloc/free fast paths lockless. 
> 
> The main race is s->cpu_slab[] and c->freelist. How does one close that
> gap?

By either reloading the cpu slab after disabling interupts (my initial 
approach) or by disabling preemption.

> (btw, have you looked at my -rt slub patch?)

I skimmed over it. Not sure what to make of it.

