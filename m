Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZIZPF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZIZPF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbZIZPFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:05:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48757 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZIZPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:05:55 -0400
Date: Sat, 26 Sep 2009 17:05:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090926150555.GM30185@one.firstfloor.org>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils> <20090926114806.GA12419@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926114806.GA12419@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However we may well end up to accept the fact that "we just cannot do
> hwpoison 100% correct", and settle with a simple and 99% correct code.

I would prefer to avoid any oopses, but if they are unlikely enough
and too hard to fix that's bearable. The race window here is certainly rather 
small. 

On the other hand if you cannot detect a difference in benchmarks I see
no reason not to add the additional steps, as long as the code isn't
complicated or ugly. These changes are neither.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
