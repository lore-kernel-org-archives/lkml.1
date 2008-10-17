Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYJQUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYJQUH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYJQUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:07:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47686
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754934AbYJQUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:07:10 -0400
Date: Fri, 17 Oct 2008 13:06:46 -0700 (PDT)
Message-Id: <20081017.130646.92681361.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: benh@kernel.crashing.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0810170850240.3438@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	<20081016.222108.13382080.davem@davemloft.net>
	<alpine.LFD.2.00.0810170850240.3438@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 17 Oct 2008 08:51:58 -0700 (PDT)

> Why do you think %08x wouldn't do that?
> 
> The "8" part is the _minimal_ part. If there really are more digits than 
> that, then you'll see them.

You probably mean "%08lx"  since plain "x" expects an "int" which is
32-bit.  At least that's my understanding.

But sure, that would work too.
