Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYLGEn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYLGEn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 23:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYLGEnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 23:43:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60682 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYLGEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 23:43:18 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
Cc: kosaki.motohiro@jp.fujitsu.com, gerald.schaefer@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, npiggin@suse.de
In-Reply-To: <1228509818.12681.21.camel@nimitz>
References: <1228482500.8392.15.camel@t60p> <1228509818.12681.21.camel@nimitz>
Message-Id: <20081207133450.53D8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun,  7 Dec 2008 13:43:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to Lee Schermerhorn


> On Fri, 2008-12-05 at 14:08 +0100, Gerald Schaefer wrote:
> > 
> > As explained above, the per-cpu pagevec layout should be independent
> > from NUMA or UNEVICTABLE_LRU, so I guess the right thing to do here
> > is completely remove the #ifdef as in the patch from Kosaki Motohiro
> > (or at least replace it with a CONFIG_SMP as suggested by Kamezawa
> > Hiroyuki).
> 
> Thanks for looking into it deeper.  That CONFIG_SMP thing really does
> look like the right solution.

Lee, Could you read this thread and explain why you add ifdef CONFIG_UNEVICTABLE_LRU?
I am not sure about that Dave's proposal is safe change. (but I guess he is right)




