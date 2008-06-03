Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbYFCWKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbYFCWKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYFCWKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:10:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52811 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYFCWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:10:05 -0400
Date: Wed, 4 Jun 2008 01:10:03 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>, johnpol@2ka.mipt.ru,
       mcmanus@ducksong.com
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
In-Reply-To: <20080603.150344.145518113.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806040104340.3474@wrl-59.cs.helsinki.fi>
References: <20080603094057.GA29480@elte.hu> <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
 <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
 <20080603.150344.145518113.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1731635768-1212531003=:3474"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1731635768-1212531003=:3474
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 3 Jun 2008, David Miller wrote:

> From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
> Date: Wed, 4 Jun 2008 01:01:25 +0300 (EEST)
> 
> > On Wed, 4 Jun 2008, Ilpo Järvinen wrote:
> > 
> > > ...I couldn't immediately find anything obviously wrong with those changes 
> > > but the patch below might be worth of a try (without the revert of 
> > > course). If it ever spits out that WARN_ON for you, we were playing with 
> > > fire too much and it's better to return on the safe side there...
> > 
> > 
> > > [PATCH] tcp DEFER_ACCEPT: see if header prediction got turned on
> > > 
> > > If header prediction is turned on under some circumstances,
> > > DA can deadlock though I have great trouble in figuring out
> > 
> > ...Nah, keepalive timer would then eventually kill it then, so no
> > deadlock seems possible through that one.
> 
> Keepalive is very long, it might still "seem" like a deadlock for
> someone without much patience :-)

Sure, but I think Ingo kept it once hang for hours, ~8h or so...
...Though I'm not sure if that qualifies as a proof of Ingo's patience 
but rather shows his willingness to help solving the matter... ;-)

-- 
 i.
---696208474-1731635768-1212531003=:3474--
