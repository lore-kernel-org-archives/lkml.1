Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYJQPys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYJQPys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYJQPwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:52:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbYJQPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:52:54 -0400
Date: Fri, 17 Oct 2008 08:51:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: benh@kernel.crashing.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <20081016.222108.13382080.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0810170850240.3438@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org> <20081016.210404.151891223.davem@davemloft.net> <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org> <20081016.222108.13382080.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, David Miller wrote:
> 
> I personally appreciate seeing the full 64-bit address on sparc64,

Umm.

Why do you think %08x wouldn't do that?

The "8" part is the _minimal_ part. If there really are more digits than 
that, then you'll see them.

		Linus
