Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYACUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYACUbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYACUbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:31:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52910 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbYACUbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:31:04 -0500
Date: Thu, 3 Jan 2008 12:31:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <20080103085239.GA10813@elte.hu>
Message-ID: <Pine.LNX.4.64.0801031230460.17023@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
 <1199314218.4497.109.camel@cinder.waste.org> <20080103085239.GA10813@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008, Ingo Molnar wrote:

> right now we are far away from it - SLUB has an order of magnitude 
> larger .o than SLOB, even on UP. I'm wondering why that is so - SLUB's 
> data structures _are_ quite compact and could in theory be used in a 
> SLOB-alike way. Perhaps one problem is that much of SLUB's debugging 
> code is always built in?

In embedded mode you can switch the debugging code off.

