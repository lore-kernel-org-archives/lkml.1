Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZHQJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZHQJ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZHQJ4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:56:37 -0400
Received: from www84.your-server.de ([213.133.104.84]:39639 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZHQJ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:56:36 -0400
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>
In-Reply-To: <20090817095250.GB10446@one.firstfloor.org>
References: <1250455161.28540.4.camel@wall-e>
	 <1250455590.28540.10.camel@wall-e>
	 <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	 <20090816163422.a147a918.akpm@linux-foundation.org>
	 <20090817074820.3585206b@lxorguk.ukuu.org.uk>
	 <1250495182.20837.27.camel@wall-e>
	 <20090817095250.GB10446@one.firstfloor.org>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 11:56:33 +0200
Message-Id: <1250502993.27083.1.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 17.08.2009, 11:52 +0200 schrieb Andi Kleen:
> > I think the break is not so hard if you believe. All you have to do is
> > to replace or kfifo_get() into kfifo_out_locked() and kfifo_put() into
> > kfifo_in_locked() if you really need the old behavior.
> > 
> > The thing is that we get no progress without changes.
> 
> One thing that would be good to ensure is that old unconverted code
> gets a clear compile time error, just in case some out of tree
> code uses it. 

This is already done.

> Bonus points also for having a short comment in kfifo.h that 
> explains how to do the conversion.
> 

I can do this on a maintainance patch.

> Other than that I would be all for getting rid of embedded spinlocks
> completely.
> 
> -Andi


