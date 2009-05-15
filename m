Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZEOIyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZEOIyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZEOIyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:54:16 -0400
Received: from night.yars.free.net ([193.233.48.54]:44483 "EHLO
	night.yars.free.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZEOIyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:54:15 -0400
Date: Fri, 15 May 2009 12:54:14 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090515085414.GA27744@night.netis.ru>
References: <20090428125755.GA5242@night.netis.ru> <49F76BF6.4040709@gmail.com> <20090429054510.GA8267@night.netis.ru> <20090429090809.GA2995@ami.dom.local> <20090508062640.GA4555@night.netis.ru> <20090508104628.GA6287@ff.dom.local> <20090510073559.GA8929@night.netis.ru> <20090510124641.GA2978@ami.dom.local> <20090515071946.GA15669@night.netis.ru> <20090515080649.GA5469@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515080649.GA5469@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 08:06:49AM +0000, Jarek Poplawski wrote:
> On Fri, May 15, 2009 at 11:19:46AM +0400, Alexander V. Lukyanov wrote:
> ...
> > Looks like 2.6.28.10 does not have this refcnt problem. Also, after I have
> > reversed net/ipv4/route.c changes from 2.6.29, the problem does not occur either.
> 
> Very nice work! It should be a piece of cake now - there were not much
> changes. I'll look at it, as usual ;-), but, of course if it's
> possible, it would be great to try "in the meantime" with reverted the
> biggest of them append below.

I suspect the problem occurs when cand==rthi.

-- 
   Alexander.
