Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZEMKUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZEMKUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbZEMKU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:20:29 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:43546 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734AbZEMKU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:20:26 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 06:20:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=rN9BoZlC0BKENAxyE8TKIF8GNfraIz/GRdXHnpE1wiOOpdRY++Dp8EXA4RiubNYxDy
         wgmYD8JzSWl9esN+hifSzNDzFUsuDazC7hayK2jhMqsF5IcVCK9fbes+bcSzeHNyH0UG
         cMmAP2fNoUNWVCUxgGcj3rcs4x1/cH9HuffmQ=
Date: Wed, 13 May 2009 19:12:21 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED
 submenu
Message-Id: <20090513191221.674bc543.minchan.kim@barrios-desktop>
In-Reply-To: <20090513175539.723A.A69D9226@jp.fujitsu.com>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com>
	<20090513175152.1590c117.minchan.kim@barrios-desktop>
	<20090513175539.723A.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 17:59:34 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Hi, Kosaki. 
> > 
> > On Wed, 13 May 2009 17:30:45 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Subject: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
> > > 
> > > Almost people always turn on CONFIG_UNEVICTABLE_LRU. this configuration is
> > > used only embedded people.
> > 
> > I think at least embedded guys don't need it. 
> > But I am not sure other guys. 
> 
> perhaps, I and you live in another embedded world.


Each people always have a different viewpoint. 
:) 

> 
> > > +config UNEVICTABLE_LRU
> > > +	bool "Add LRU list to track non-evictable pages" if EMBEDDED
> > > +	default y
> > 
> > If you want to move, it would be better as following.
> > 
> > config UNEVICTABLE_LRU
> >        bool "Add LRU list to track non-evictable pages" if EMBEDDED
> >        default !EMBEDDED
> 
> No.
> As far as I know, many embedded guys use this configuration.
> they hate unexpected latency by reclaim. !UNEVICTABLE_LRU increase
> unexpectability largely.

As I said previous(http://lkml.org/lkml/2009/3/16/209), Many embedded environment have a small ram. It doesn't have a big impact in such case. 

Let CCed embedded matainers. 
I won't have a objection if embedded maintainers ack this. 

Thanks for your effort for embdded. 

-- 
Kinds Regards
Minchan Kim
