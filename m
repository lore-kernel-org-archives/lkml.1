Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZEVKwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZEVKwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZEVKwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:52:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:35594 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZEVKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:52:12 -0400
Date: Fri, 22 May 2009 19:51:46 +0900
To: jeremy@goop.org
Cc: beckyb@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ian.Campbell@citrix.com
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A15B72E.2070202@goop.org>
References: <4A1592CF.8000208@goop.org>
	<E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
	<4A15B72E.2070202@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522194930E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 19:51:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 13:18:54 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Becky Bruce wrote:
> > I can work with that, but it's going to be a bit inefficient, as I 
> > actually need the dma_addr_t, not the phys_addr_t, so I'll have to 
> > convert.  In every case, this is a conversion I've already done and 
> > that I need in the calling code as well.  Can we pass in both the 
> > phys_addr_t and the dma_addr_t?
> 
> The Xen implementation would needs to do the phys to bus conversion page 
> by page anyway, so it wouldn't help much.  But it also wouldn't hurt.
> 
> How expensive is the phys-to-bus conversion on power?  Is it worth 
> making the interface more complex for?  Would passing phys+bus mean that 
> we wouldn't also need to pass dev?

I don't think so. POWERPC needs it.
