Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZEMI7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZEMI7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZEMI7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:59:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54931 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZEMI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:59:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090513175152.1590c117.minchan.kim@barrios-desktop>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com> <20090513175152.1590c117.minchan.kim@barrios-desktop>
Message-Id: <20090513175539.723A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 17:59:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Kosaki. 
> 
> On Wed, 13 May 2009 17:30:45 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
> > 
> > Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
> > used only embedded people.
> 
> I think at least embedded guys don't need it. 
> But I am not sure other guys. 

perhaps, I and you live in another embedded world.


> > +config UNEVICTABLE_LRU
> > +	bool "Add LRU list to track non-evictable pages" if EMBEDDED
> > +	default y
> 
> If you want to move, it would be better as following.
> 
> config UNEVICTABLE_LRU
>        bool "Add LRU list to track non-evictable pages" if EMBEDDED
>        default !EMBEDDED

No.
As far as I know, many embedded guys use this configuration.

they hate unexpected latency by reclaim. !UNEVICTABLE_LRU increase
unexpectability largely.




