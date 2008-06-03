Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbYFCWD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYFCWD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYFCWDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:03:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48410
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbYFCWDp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:03:45 -0400
Date: Tue, 03 Jun 2008 15:03:44 -0700 (PDT)
Message-Id: <20080603.150344.145518113.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, rjw@sisk.pl, akpm@linux-foundation.org,
       johnpol@2ka.mipt.ru, mcmanus@ducksong.com
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
References: <20080603094057.GA29480@elte.hu>
	<Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
	<Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Wed, 4 Jun 2008 01:01:25 +0300 (EEST)

> On Wed, 4 Jun 2008, Ilpo Järvinen wrote:
> 
> > ...I couldn't immediately find anything obviously wrong with those changes 
> > but the patch below might be worth of a try (without the revert of 
> > course). If it ever spits out that WARN_ON for you, we were playing with 
> > fire too much and it's better to return on the safe side there...
> 
> 
> > [PATCH] tcp DEFER_ACCEPT: see if header prediction got turned on
> > 
> > If header prediction is turned on under some circumstances,
> > DA can deadlock though I have great trouble in figuring out
> 
> ...Nah, keepalive timer would then eventually kill it then, so no
> deadlock seems possible through that one.

Keepalive is very long, it might still "seem" like a deadlock for
someone without much patience :-)
