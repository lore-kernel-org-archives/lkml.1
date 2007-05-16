Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbXEPGjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbXEPGjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbXEPGjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:39:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36030
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbXEPGje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:39:34 -0400
Date: Tue, 15 May 2007 23:39:40 -0700 (PDT)
Message-Id: <20070515.233940.48528771.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Slab allocators: Define common size limitations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070515233239.335bd4ed.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com>
	<20070515233239.335bd4ed.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 23:32:39 -0700

> rofl. Really we shouldn't put this into 2.6.22, but it turfs out so much
> crap that it's hard to justify holding it back.

If fixes sparc64 with SLAB for one thing.  I was going to put
LARGE_ALLOCS back into sparc64/Kconfig but this is just soooo
much better.
