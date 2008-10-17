Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbYJQGjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbYJQGjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYJQGjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:39:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46516 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYJQGjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:39:43 -0400
Message-ID: <48F83257.6000501@zytor.com>
Date: Thu, 16 Oct 2008 23:36:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <48F409E9.3030501@zytor.com>	 <20081013.223811.174710738.davem@davemloft.net>	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>	 <20081016.013850.85183428.davem@davemloft.net>	 <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>	 <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org> <1224216310.7654.74.camel@pasglop>
In-Reply-To: <1224216310.7654.74.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> 
> I hesitated, but DaveM convinced me if you get a range of IO ports such
> as 138-139, do you know on a first look that it's hex ? :-)
> 

Yes.  I mean, at least in the x86 world, we talk about "port eighty" for 
delays, which is really port 128 (0x80).

>> and the 04 would be parsed as flags, the same way we do %04x. And then if 
>> you want the 0x, you can use %p#08R..
> 
> Shouldn't we be consistent and have resources always be printed using
> the same format ?

Yes, please.

	-hpa

