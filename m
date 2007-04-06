Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbXDFUbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbXDFUbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXDFUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:31:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44508 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932853AbXDFUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:31:49 -0400
Date: Fri, 6 Apr 2007 13:31:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: Add Kconfig option for SLAB quirks
In-Reply-To: <20070406132634.1f64d4a1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704061328270.23939@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704061227170.11797@schroedinger.engr.sgi.com>
 <20070406132634.1f64d4a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Andrew Morton wrote:

> urgh.  It would be better to continue to rework slab/slub callers in the
> fashion which you have been doing, don't you think?

Yes definitely but I do not want to risk getting slub dropped from mm.

> Rephrasing my earlier point: are we doing things in the correct order here,
> and efficiently?  It is not settled in my mind whether we want to merge
> slub _at all_.  Do we have enough information yet to be able to make that
> decision?

Check the initial SLUB_V6 patch? It has long list of issues that were 
addressed.

> And if that information indicates that a slub merge _is_ justified, why is
> the chosen approach superior to the incremental one: if slab code is grotty
> (it is), clean it up.  If slab has unnecessary stuff, delete it.

SLUB is a fundamentally different design. We can address some of the 
warts in SLAB as we do the cleanup but the basic way of handling objects 
on queues is core to SLAB and is not used at all in SLUB.

