Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYJQGn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYJQGn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJQGnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:43:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYJQGnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:43:16 -0400
Message-ID: <48F83316.5080107@zytor.com>
Date: Thu, 16 Oct 2008 23:39:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rdreier@cisco.com, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>	 <20081016.210404.151891223.davem@davemloft.net>	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>	 <20081016.222108.13382080.davem@davemloft.net> <1224225365.7654.88.camel@pasglop>
In-Reply-To: <1224225365.7654.88.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> 
> The latest patch I posted will do full size of resource_size_t unless
> you arch explicitely adds a #define to do it differently so that
> should work for you :-)
> 

IMNSHO I think you can default to 8 digits for I/O for PCI, since at 
least last I looked there was no 64-bit address space possible for I/O.

	-hpa
