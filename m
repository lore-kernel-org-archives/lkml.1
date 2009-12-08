Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZLHORB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZLHORB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZLHORA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:17:00 -0500
Received: from sh.osrg.net ([192.16.179.4]:38562 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbZLHOQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:16:56 -0500
Date: Tue, 8 Dec 2009 23:16:09 +0900
To: mingo@elte.hu
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: gart: fix the HW IOMMU initialization rewrite
 breakage
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1260270299-18325-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1260270299-18325-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091208231538S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 08 Dec 2009 23:16:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Dec 2009 20:04:57 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Here is the output of discussion with Yinghai Lu. This patchset fixes
> GART isses due to the commit 75f1cdf1dda92cae037ec848ae63690d91913eac
> (x86: Handle HW IOMMU initialization failure gracefully).
> 
> I split Yinghai's v4 patch to make the changes clearer (and fixed the
> comment a bit) however there is no functional change:
> 
> http://marc.info/?l=linux-kernel&m=125965342214387&w=2
> 
> The first patch is a sligtly modified version of my patch to move back
> swiotlb initialization after IOMMU detection:
> 
> http://marc.info/?l=linux-kernel&m=125907069703595&w=2
> 
> I put the detailed descriptions to both.

Sorry, the description in the first patch is wrong.

I'll retry tomorrow. Please discard this.
