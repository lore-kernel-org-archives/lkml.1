Return-Path: <linux-kernel-owner+w=401wt.eu-S1946551AbXBQKCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946551AbXBQKCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946596AbXBQKCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:02:14 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43822 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946551AbXBQKCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:02:13 -0500
Date: Sat, 17 Feb 2007 13:02:00 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070217100159.GA15971@2ka.mipt.ru>
References: <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org> <20070216160525.GA21160@2ka.mipt.ru> <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com> <20070216165854.GA18522@2ka.mipt.ru> <20070216202036.GA10190@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070216202036.GA10190@cvg>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 17 Feb 2007 13:02:10 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 11:20:36PM +0300, Cyrill V. Gorcunov (gorcunov@gmail.com) wrote:
> On Fri, Feb 16, 2007 at 07:58:54PM +0300, Evgeniy Polyakov wrote:
> | Absolutely.
> | And if overall system design is good, there is no problem to change
> | (well, for those who fail to read to the end and understand my english
> | replace 'to change' with 'to create and commit') interface to the state
> | where it will satisfy all (majority of) users.
> | 
> | Situations when system is designed from interface down to system ends up
> | with one thread per IO and huge limitations on how system is going to be
> | used at all.
> | 
> | -- 
> | 	Evgeniy Polyakov
> 
> I'm sorry for meddling in conversation but I think Linus misunderstood
> you. If I'm right you propose to "create and commit" _new_ interfaces
> only? I mean _changing_ of interfaces exported to user space is
> very painfull... for further support. Don't swear at me if I wrote
> something stupid ;)

Yes, I only proposed to change what Ingo has right now - although it is
usable, but it does suck, but since overall syslet design is indeed good
it does not suffer from possible interface changes - so I said that it
can be trivially changed in that regard that until it is committed
anything can be done to extend it.

> -- 
> 
> 		Cyrill

-- 
	Evgeniy Polyakov
