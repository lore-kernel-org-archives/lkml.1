Return-Path: <linux-kernel-owner+w=401wt.eu-S1761064AbXEKQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064AbXEKQQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbXEKQP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:15:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55526 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757977AbXEKQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:15:59 -0400
Date: Fri, 11 May 2007 09:15:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
In-Reply-To: <20070511075410.GT19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705110914000.19153@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
 <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com>
 <20070511082930.GP2012@bingen.suse.de> <20070511004200.6d30152e.akpm@linux-foundation.org>
 <20070511075410.GT19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, William Lee Irwin III wrote:

> My summary:
> (1) The patch is safe-as is, though it should move its hook elsewhere.
> (2) Scribbling on the memory still irks me but is safe.
> (3) I should redo the i386 pgd updates to suck less.
> (4) Christoph might let me change quicklists to use struct page pointers.

I am fine with you working on it. You just need to coordinate with the 7 
or so arches that are now using quicklists.

> Christoph wants to update the core quicklist code or have me update
> it according to the cached precomputed value scheme I outlined in a
> prior post before its initial merge. I'll prepare all the patches for
> comment regardless.

I am fine with you updating the quicklist code since I have currently no 
plans on doing more there. Just be sure to coordinate with all quicklists 
users please.
