Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXGEW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXGEW1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761323AbXGEW12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:27:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44048 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169AbXGEW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:27:27 -0400
Date: Fri, 6 Jul 2007 07:27:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mike Stroyan <mike@stroyan.net>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-mm@kvack.org, clameter@sgi.com,
       y-goto@jp.fujitsu.com, dmosberger@gmail.com, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [BUGFIX][PATCH] DO flush icache before set_pte() on ia64.
Message-Id: <20070706072707.6d71b198.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070705181308.GB8320@stroyan.net>
References: <20070704150504.423f6c54.kamezawa.hiroyu@jp.fujitsu.com>
	<20070705181308.GB8320@stroyan.net>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 12:13:09 -0600
Mike Stroyan <mike@stroyan.net> wrote:

> You don't seem to have removed the lazy_mmu_prot_update() calls from
> mm/hugetlb.c.  Will that build with HUGETLBFS configured?
> 
Thanks, it's my patch refresh miss... Sigh..

-Kame

