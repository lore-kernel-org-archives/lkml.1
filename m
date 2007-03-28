Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXC1Vi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXC1Vi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXC1Vi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:38:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53582 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156AbXC1Vi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:38:56 -0400
Date: Wed, 28 Mar 2007 14:38:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070328212459.GY8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703281435330.14017@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328205055.GX8915@holomorphy.com> <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com>
 <20070328212459.GY8915@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:

> I'd also appreciate if it were mentioned who actually wrote this, given
> that the patch posted was what I sent you verbatim (and actually
> requested you not post for good reasons, some centering around pageattr.c).

Ughhh. Sorry I had this in there in early editions but removed the 
paragraph later.

> The salient point from the above, which was conveniently omitted, was
> "it's all dominated by PTE caching." However, even this needs some
> qualification having to do with the VSZ of the parent process in fork().
> For very small processes, such as cannot be constructed with glibc due
> to its massive bloat and cannot be constructed with the standard process
> address space layouts due to stacks being too distant from text and
> heap, PTE's actually don't substantially outnumber PMD's et al, so
> there is more to this story.

No that was described in the patch. Quote:

"i386 only provides support for caching constructed pgd and pmds. These 
are comparatively rare to ptes so it is no surprise that the current 
approach has only minimal effect. ...."
