Return-Path: <linux-kernel-owner+w=401wt.eu-S1752410AbZGFEYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbZGFEYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 00:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZGFEYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 00:24:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36898 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZGFEYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 00:24:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/5] add buffer cache information to show_free_areas()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <28c262360907050716x28671070of7ab21556213b337@mail.gmail.com>
References: <20090705182337.08F9.A69D9226@jp.fujitsu.com> <28c262360907050716x28671070of7ab21556213b337@mail.gmail.com>
Message-Id: <20090706132340.52B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Jul 2009 13:24:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -2118,7 +2118,7 @@ void show_free_areas(void)
> > ? ? ? ?printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> > ? ? ? ? ? ? ? ?" inactive_file:%lu"
> > ? ? ? ? ? ? ? ?" unevictable:%lu"
> > - ? ? ? ? ? ? ? " dirty:%lu writeback:%lu unstable:%lu\n"
> > + ? ? ? ? ? ? ? " dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
> > ? ? ? ? ? ? ? ?" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> > ? ? ? ? ? ? ? ?" mapped:%lu pagetables:%lu bounce:%lu\n",
> > ? ? ? ? ? ? ? ?global_page_state(NR_ACTIVE_ANON),
> > @@ -2128,6 +2128,7 @@ void show_free_areas(void)
> > ? ? ? ? ? ? ? ?global_page_state(NR_UNEVICTABLE),
> > ? ? ? ? ? ? ? ?global_page_state(NR_FILE_DIRTY),
> > ? ? ? ? ? ? ? ?global_page_state(NR_WRITEBACK),
> > + ? ? ? ? ? ? ? K(nr_blockdev_pages()),
> 
> Why do you show the number with kilobyte unit ?
> Others are already number of pages.
> 
> Do you have any reason ?

Good catch. this is simple mistake.
I'll fix it.


