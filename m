Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbYJRWzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbYJRWzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYJRWzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:55:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYJRWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:55:01 -0400
Date: Sat, 18 Oct 2008 15:53:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jon Smirl <jonsmirl@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Keith Packard <keithp@keithp.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [git pull] drm patches for 2.6.27-rc1
In-Reply-To: <9e4733910810181547k98f2a02p82769c51975f5865@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810181551590.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>  <200810181237.49784.nickpiggin@yahoo.com.au>  <1224357062.4384.72.camel@koto.keithp.com>  <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>  <20081018203741.GA23396@elte.hu>
  <1224366690.4384.89.camel@koto.keithp.com>  <20081018223214.GA5093@elte.hu> <9e4733910810181547k98f2a02p82769c51975f5865@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Jon Smirl wrote:
> 
> Is it possible to use a segment register to map the whole aperture on
> 32b?

No. Segment registers don't extend the virtual address space, they can 
only limit visibility into the one single 32-bit one.

IOW, segment registers don't actually extend addressing in any way, they 
only limit it. There's a reason why people don't use them (except as a 
strange base register for things like per-cpu or per-thread variables, and 
that is not to extend the address space, but to avoid wasting precious 
_useful_ registers on that).

			Linus
