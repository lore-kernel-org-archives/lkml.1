Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYJQGgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYJQGgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYJQGgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:36:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:55621 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbYJQGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:36:41 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <20081016.222108.13382080.davem@davemloft.net>
References: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	 <20081016.222108.13382080.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 17:36:05 +1100
Message-Id: <1224225365.7654.88.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 22:21 -0700, David Miller wrote:
> 
> I personally appreciate seeing the full 64-bit address on sparc64,
> even for IORESOURCE_IO, and that's helped me debug resource
> calculation bugs on more than one occasion in the past.

The latest patch I posted will do full size of resource_size_t unless
you arch explicitely adds a #define to do it differently so that
should work for you :-)

Cheers,
Ben.


