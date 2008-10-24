Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYJXDYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYJXDYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 23:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYJXDYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 23:24:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:42716 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYJXDYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 23:24:45 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Keith Packard <keithp@keithp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       nickpiggin@yahoo.com.au, airlied@linux.ie,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, yinghai@kernel.org,
       Peter Anvin <hpa@zytor.com>
In-Reply-To: <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
	 <1224813015.22877.51.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 14:24:05 +1100
Message-Id: <1224818645.7654.431.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 19:48 -0700, Linus Torvalds wrote:
> Then, there's the issue of 64-bit, and just mapping everything there, and 
> the interface to that. I liked the trivial extension to "struct resource" 
> to have a "cached mapping" pointer. So if we can just make it pass 
> resources around and get a page that way (and not even need kmap() on 
> 64-bit architections), that would be good.

I'm not that fan of carrying a mapping with a struct resource because if
we do that we should probably also refcount the mapping, and then there
is the whole question of mappings with different attributes, etc etc...

Cheers,
Ben.


