Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXERAsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXERAsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbXERAs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:48:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59744 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbXERAsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:48:25 -0400
X-Greylist: delayed 82020 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 20:48:24 EDT
Date: Fri, 18 May 2007 09:48:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Subject: Re: [PATCH] fix kmalloc(0) in arch/ia64/pci/pci.c
Message-Id: <20070518094857.572e804e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070517121959.b1b374fa.akpm@linux-foundation.org>
References: <20070517110056.779944a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20070517121959.b1b374fa.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 12:19:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	if (!windows)
> > +		goto out2;
> >  	controller->window = kmalloc_node(sizeof(*controller->window) * windows,
> >  			GFP_KERNEL, controller->node);
> >  	if (!controller->window)
> > 
> 
> This is a significant change in functionality.  Can you please explain why
> it doesn't break things?
> 
Sorry for long RTT. I found no problem on my machine, but....
I realized I misunderstood how kmalloc(0) works....sorry, please drop patch.

I'll ask a pci guy to fix this.

-Kame

