Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXGRFqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXGRFqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXGRFq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:46:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbXGRFq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:46:29 -0400
Date: Tue, 17 Jul 2007 22:45:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Joe Jin <joe.jin@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       bill.irwin@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070717224515.869f7040.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
	<20070717093228.3a3638aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
	<20070717115849.9f5e435c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com>
	<20070717130118.bc78d31a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com>
	<20070718014027.GA23559@joejin-pc.cn.oracle.com>
	<Pine.LNX.4.64.0707180521470.18593@blonde.wat.veritas.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 05:49:50 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> > With your patch, I have reproduced the panic:
> 
> That is... surprising to me.

To me also.  I'd like to double-check the code which Joe actually
tested, please - have a sneaking suspicion that the 2.6.22 version
of that function was tested ;)
