Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbYEES6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbYEES6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYEES6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:58:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54832 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYEES6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:58:40 -0400
Message-ID: <481F58DD.9000600@firstfloor.org>
Date: Mon, 05 May 2008 20:58:37 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [rfc][patch 0/3] bootmem2: a memory block-oriented boot time
 allocator
References: <20080505095938.326928514@symbol.fehenstaub.lan>
In-Reply-To: <20080505095938.326928514@symbol.fehenstaub.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (because a PFN is not unique anymore)

That doesn't make sense. If a PFN is not uniquely mapping to a single
memory page anymore the VM and lots of other code in the kernel will
just not work. And each memory page can be only in a single node.

-Andi
