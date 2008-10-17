Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYJQUfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYJQUfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYJQUfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:35:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYJQUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:35:02 -0400
Message-ID: <48F8F5F9.1050506@zytor.com>
Date: Fri, 17 Oct 2008 13:30:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, yhlu.kernel@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>  <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>  <20081016.210404.151891223.davem@davemloft.net>  <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org> <1224220339.7654.84.camel@pasglop> <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> And even on sparc, with the full 64 bits in use, it's not like we'd be 
> *truncating* to 4 hex digits with %04x.
> 

This reminds me to add support for the ' modifier in the kernel printk...

	-hpa
