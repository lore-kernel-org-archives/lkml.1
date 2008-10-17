Return-Path: <linux-kernel-owner+w=401wt.eu-S1751802AbYJQEFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbYJQEFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYJQEE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:04:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42684
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbYJQEE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:04:28 -0400
Date: Thu, 16 Oct 2008 21:04:04 -0700 (PDT)
Message-Id: <20081016.210404.151891223.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: benh@kernel.crashing.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com>
	<1224214314.7654.65.camel@pasglop>
	<alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Oct 2008 20:49:00 -0700 (PDT)

> But it would be kind of nice to be able to do extended flags. Maybe we 
> could do it with
> 
> 	%p04R
> 
> and the 04 would be parsed as flags, the same way we do %04x. And then if 
> you want the 0x, you can use %p#08R..

These modifiers are interesting, but wouldn't it be even nicer to just
pick one output style and use it consistently in kernel messages for
resources?
