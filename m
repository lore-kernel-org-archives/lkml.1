Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbYDXH6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbYDXH6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYDXH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:58:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbYDXH6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:58:30 -0400
Date: Thu, 24 Apr 2008 00:58:23 -0700 (PDT)
Message-Id: <20080424.005823.19184500.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: gordonfarquharson@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       netdev@vger.kernel.org
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209021852.9212.936.camel@pmac.infradead.org>
References: <1209021399.9212.927.camel@pmac.infradead.org>
	<20080424.002038.201593352.davem@davemloft.net>
	<1209021852.9212.936.camel@pmac.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 24 Apr 2008 08:24:12 +0100

> On Thu, 2008-04-24 at 00:20 -0700, David Miller wrote:
> > But won't the request_module() for AF_UNIX spit out that warning too?
> 
> Yes. If you build AF_UNIX as a module, it will. Just once though, before
> loading it (assuming it's available).
> 
> > Actually, I think I need a clarification.  It is the modular loader
> > utility in userspace which is trying to open up AF_UNIX sockets,
> > right?
> 
> Yes. Or probably libc.

Ok, I'll apply your patch, but really this all feels like a jumble
of hacks to me :-)
