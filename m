Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXEJVtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXEJVtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXEJVtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:49:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38910 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754560AbXEJVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:49:32 -0400
Date: Thu, 10 May 2007 14:49:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>,
       linux-kernel@vger.kernel.org, Nicolas.Mailhot@LaPoste.net,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2,
 mode:0x84020
In-Reply-To: <20070510144319.48d2841a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com>
References: <200705102128.l4ALSI2A017437@fire-2.osdl.org>
 <20070510144319.48d2841a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Andrew Morton wrote:

> Christoph, can we please take a look at /proc/slabinfo and its slub
> equivalent (I forget what that is?) and review any and all changes to the
> underlying allocation size for each cache?
> 
> Because this is *not* something we should change lightly.

It was changed specially for mm in order to stress the antifrag code. If 
this causes trouble then do not merge the patches against SLUB that 
exploit the antifrag methods. This failure should help see how effective 
Mel's antifrag patches are. He needs to get on this dicussion.

Upstream has slub_max_order=1.
