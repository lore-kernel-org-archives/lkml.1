Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZAMHWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZAMHWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 02:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZAMHWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 02:22:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36445
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbZAMHWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:22:06 -0500
Date: Mon, 12 Jan 2009 23:22:05 -0800 (PST)
Message-Id: <20090112.232205.196691083.davem@davemloft.net>
To: sam@ravnborg.org
Cc: jaswinder@infradead.org, mingo@elte.hu, harvey.harrison@gmail.com,
       gorcunov@gmail.com, roque@di.fc.ul.pt, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH -tip] in6.h: extern's make no sense in userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090113071513.GB20036@uranus.ravnborg.org>
References: <1231829859.3212.19.camel@jaswinder.satnam>
	<20090113071513.GB20036@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 13 Jan 2009 08:15:13 +0100

> On Tue, Jan 13, 2009 at 12:27:39PM +0530, Jaswinder Singh Rajput wrote:
> > +#ifdef __KERNEL__
> >  extern const struct in6_addr in6addr_any;
> >  #define IN6ADDR_ANY_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } } }
> >  extern const struct in6_addr in6addr_loopback;
> >  #define IN6ADDR_LOOPBACK_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 } } }
> > -#ifdef __KERNEL__
> 
> It looks wrong what IN6ADDR_ANY_INIT should be a kernel only symbol.
> At least google had some hits on that symbol.
> 
> netdev people should know....

It is defined by libc's /usr/include/netinet/in.h
