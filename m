Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYL1FCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYL1FCG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 00:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYL1FBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 00:01:55 -0500
Received: from gw.goop.org ([64.81.55.164]:55524 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYL1FBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 00:01:54 -0500
Message-ID: <4957083B.6090801@goop.org>
Date: Sun, 28 Dec 2008 16:01:47 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
References: <patchbomb.1229970362@abulafia.goop.org>	<20081227104823.GI14639@elte.hu> <20081228000558I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228000558I.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> Well, I asked Jeremy to use Becky's approach so I don't have though
> this patchset isn't enough for Becky (possibly for Xen too) since
> Jeremy didn't put Becky's map_single_page changes. These changes are
> necessary to support map_map_page with highmem. I think that we can do
> it simpler than his patch. I'll send patches to that in a different
> way soon.
>
> It's not principal objection, but as I said, the patches to revert
> Jeremy's highmem patches in this patchset like the following are
> pointless.
>   

I don't mind either way.  I was hoping to go with something that I've 
actually tested, but I don't see any reason why Becky's patches won't 
work in principle for Xen.  I'm on vacation at the moment, but I can 
test things out when I get back in a couple of weeks and apply whatever 
fixes are needed at whatever stage we're at then.

    J
