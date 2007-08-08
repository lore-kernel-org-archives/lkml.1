Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbXHHQAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbXHHQAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXHHQAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:00:39 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:55314 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbXHHQAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:00:38 -0400
Date: Wed, 8 Aug 2007 12:00:31 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Andi Kleen <ak@suse.de>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drop unneeded variable in amd_apic_timer_broken
In-Reply-To: <200708081636.20223.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0708081146120.25865@lancer.cnet.absolutedigital.net>
References: <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
 <20070808000631.GB7353@one.firstfloor.org>
 <Pine.LNX.4.64.0708072030440.28681@lancer.cnet.absolutedigital.net>
 <200708081636.20223.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Andi Kleen wrote:

> Can you please test if this patch works?

Yep, seems to do the trick. Thanks!

> BTW I checked with AMD and they seem to think it's just a buggy BIOS.

Nod. Atleast we can work around it.

> Use global flag to disable broken local apic timer on AMD CPUs.
> 
> The Averatec 2370 laptop BIOS seems to program the ENABLE_C1E

s~2370~2370/2371~ to be completely accurate ;)

> MSR inconsistently between cores. This confuses the lapic
> use heuristics wants to know if C1E is enabled anywhere.
> 
> Use a global flag instead of a per cpu flag to handle this.
> If any CPU has C1E enabled disabled lapic use.
> 
> Thanks to Cal Peake for debugging.
> Signed-off-by: Andi Kleen <ak@suse.de>

Acked-by: Cal Peake <cp@absolutedigital.net>

-- 
Cal Peake


