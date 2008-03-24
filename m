Return-Path: <linux-kernel-owner+w=401wt.eu-S1763263AbYCXSdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263AbYCXSdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbYCXScx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:32:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55415 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758333AbYCXScw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:32:52 -0400
Date: Mon, 24 Mar 2008 11:31:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [00/14] Virtual Compound Page Support V3
In-Reply-To: <20080322114043.17833ab4@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0803241129100.3002@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080322114043.17833ab4@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Arjan van de Ven wrote:

> can you document the drawback of large, frequent vmalloc() allocations at least?

Ok. Lets add some documentation about this issue and some other 
things. A similar suggestion was made by Kosaki-san.

> On 32 bit x86, the effective vmalloc space is 64Mb or so (after various PCI bars are ioremaped),
> so if this type of allocation is used for a "scales with nr of ABC" where "ABC" is workload dependent,
> there's a rather abrupt upper limit to this.
> Not saying that that is a flaw of your patch, just pointing out that we should discourage usage of 
> the "scales with nr of ABC" (for example "one for each thread") kind of things.

I better take out any patches that do large scale allocs then.
