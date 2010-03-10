Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0CJHQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 02:16:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35810
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab0CJHQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 02:16:17 -0500
Date: Tue, 09 Mar 2010 23:16:35 -0800 (PST)
Message-Id: <20100309.231635.199019630.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, yinghai@kernel.org, x86@kernel.org,
       linux-arch@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: further plans on bootmem, was: Re: -
 bootmem-avoid-dma32-zone-by-default.patch removed from -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100310000121.GA9985@cmpxchg.org>
References: <4B96B923.7020805@kernel.org>
	<20100309134902.171ba2ae.akpm@linux-foundation.org>
	<20100310000121.GA9985@cmpxchg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 10 Mar 2010 01:01:21 +0100

> I also found it weird that it makes x86 skip an allocator level that all
> the other architectures are using, and replaces it with 'generic' code that
> nobody but x86 is using (sparc, powerpc, sh and microblaze  appear to have
> lib/lmb.c at this stage and for this purpose? lmb was also suggested by
> benh [4] but I have to admit I do not understand Yinghai's response to it).

It kind of irked me that lmb was passed over for whatever vague reason
was given.

It works fine with memory hotplug on powerpc, so a lack of hotplug
support can't be an argument for not using it.

But hey, having yet another early memory allocator instead of making
one of the existing ones do what you want, that's fine right?
