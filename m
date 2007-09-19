Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbXISRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbXISRoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXISRoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:44:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXISRoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:44:05 -0400
Message-ID: <46F15ED4.40002@zytor.com>
Date: Wed, 19 Sep 2007 10:39:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20070919130122.GA21750@Krystal> <46F14A58.60904@zytor.com> <46F15CB8.6010408@goop.org>
In-Reply-To: <46F15CB8.6010408@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Cross-cache-line, sure.  But what about just not sizeof aligned?  If its
> enough to avoid cross-cache-line, then that's simpler.
> 

Not really.  It pretty much comes down to the same problem.

> Which is something I was going to comment on: Mathieu, you try to align
> the constant itself, but you don't prevent the instruction overall from
> crossing a cache line.  Given how delicate all this stuff is, it seems
> like a good idea to do that.

Given how delicate all his stuff is, it would be interesting to know the
magnitude of the expected payoff, which I personally don't remember seeing.

	-hpa

