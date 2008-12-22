Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYLVSo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYLVSo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYLVSoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:44:16 -0500
Received: from sh.osrg.net ([192.16.179.4]:42294 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbYLVSoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:44:16 -0500
Date: Tue, 23 Dec 2008 03:43:42 +0900
To: jeremy@goop.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, beckyb@kernel.crashing.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
References: <patchbomb.1229970362@abulafia.goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081223034327A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008 10:26:02 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi all,
> 
> Here's a work in progress series whcih does a partial revert of the
> previous swiotlb changes, and does a partial replacement with Becky
> Bruce's series.
> 
> The most important difference is Becky's use of phys_addr_t rather
> than page+offset to represent arbitrary pages.  This turns out to be
> simpler.

Great, thanks a lot!

But I think that we should just drop the previous patchset
completely and start cleanly.


> I didn't replicate the map_single_page changes, since I'm not exactly
> sure of ppc's requirements here, and it seemed like something that
> could be easily added.

I think the patch is not necessary. Just exporting map_single should
be fine.
