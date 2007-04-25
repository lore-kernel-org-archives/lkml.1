Return-Path: <linux-kernel-owner+w=401wt.eu-S2993031AbXDYUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993031AbXDYUD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993041AbXDYUD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:03:28 -0400
Received: from gw.goop.org ([64.81.55.164]:40724 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993031AbXDYUD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:03:26 -0400
Message-ID: <462FB42F.5070503@goop.org>
Date: Wed, 25 Apr 2007 13:03:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ian Pratt <ian.pratt@xensource.com>, lkml <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
References: <20070423215638.563901986@goop.org> <200704251112.45898.ak@suse.de> <462FAEE3.9090900@goop.org> <200704252143.48363.ak@suse.de>
In-Reply-To: <200704252143.48363.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> For me you don't need anymore, but possibly for others.
>   

Hm.  I'm not a fan of the great big monolithic patch myself, but on the
other hand I don't like the idea of patches which are not self-contained
steps from working->working state.  Xen-core.patch is currently the
(more or less) minimal set of stuff which needs to be in place to get
working Xen guest up, and so from that perspective I don't think there's
a good way of splitting it up.

> To summarize the outstanding issues are:
> - fixing sched_clock first
>   

What was the sched_clock problem?  I don't remember and outstanding
issues with it.  I noticed you didn't take paravirt-sched_clock.

> - hopefully more review of the core pieces by others
> - what i commented (minor stuff mostly)
>   

I just rebased onto your newest patches, so I'll address your comments
and repost.

> - review of xenbus and drivers

Yes, not much response there.

    J
