Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZDGCZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZDGCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZDGCZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:25:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:46143 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZDGCZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:25:10 -0400
Date: Tue, 7 Apr 2009 11:24:42 +0900
To: beckyb@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Subject: Re: [PATCH V2 0/7] swiotlb: changes for powerpc/highmem
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090407112448L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 07 Apr 2009 11:24:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Apr 2009 20:56:42 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> This is v2 of a series of fairly minor patches that get swiotlb
> working on 32-bit powerpc systems with HIGHMEM, plus some cleanup
> of the outdated comments in the code. I've made a couple of things
> weak that ppc needs to override, and have changed the prototypes
> for a couple of functions to include the hwdev pointer, which
> we need to ppc to convert bus addresses to and from phys/virt
> addresses. I've also fixed a build warning I've been seeing on
> ppc.
> 
> In response to commentary on the previous series, I've also
> refactored the code a bit, altough I did this slightly
> differently than was suggested because I noticed we could use the
> new helper function in 2 places instead of one. I've reformatted
> a bit of code based on commentary as well.
> 
> I have not tested this in any way on any non-ppc platforms,
> so commentary/testing from x86/ia64 folks is, once again,
> greatly appreciated.
> 
> I'm going to be offline for the next week, but will respond to
> commentary as soon as I return.
> 
> Cheers,
> Becky
> 
> diffstat:
> arch/x86/kernel/pci-swiotlb.c |    2 +-
> include/linux/swiotlb.h       |    3 +-
> lib/swiotlb.c                 |  115 ++++++++++++++++++++++-------------------
> 3 files changed, 64 insertions(+), 56 deletions(-)

I have a minor comment on 5/7 but the rest looks fine to me.
