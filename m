Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbXA0TZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbXA0TZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 14:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXA0TZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 14:25:37 -0500
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:47460 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752360AbXA0TZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 14:25:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZRqjh4lawAS5hL7sYD1gFfGIdXuRUipxRNVcsJuixjFwKBTvCnnnqBO+abLGIXIuaOminn+v3LQiBT3voi5n2UooKDfuluoMZWc/NyWYAfPQGG2XlKPdEWNKXZLzQaS6pl6sw8GyLmlxAfNqr87Bp2L9QvXABAFsNVHeUIO/NJY=  ;
X-YMail-OSG: UtRpZ2AVM1k5PzoJJF42Kj3Ljg4L56JpmdFqHGDktT.Hv2Zj4hbPv_dGQTY5STdyz_jCN005mrhJuvX5z37nV3m1eXWDn4n03IRL19BiXf_VkaVxO7o-
From: David Brownell <david-b@pacbell.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Subject: Re: [PATCH 1/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Date: Sat, 27 Jan 2007 11:25:32 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701271011.l0RAB3MD018814@ignucius.se.axis.com>
In-Reply-To: <200701271011.l0RAB3MD018814@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701271125.33121.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 January 2007 2:11 am, Hans-Peter Nilsson wrote:
> > From: David Brownell <david-b@pacbell.net>
> > Date: Fri, 26 Jan 2007 15:21:15 -0800
> 
> > > >  That flag could work in conjunction with a byte
> > > 
> > > Or why not a 32-bit word!
> > 
> > If a driver wants a repeating 32-bit pattern, they should just
> > provide a properly initialized tx buffer.
> 
> I'm suggesting the default_tx_word be able to fill out "common"
> values of bits_per_word when > 8, else it'd be useless as a
> 1-filler for larger sizes than byte.  Making it a single bit
> then wouldn't cater to your debug-with-scope use-case.

That wasn't my idea, it was borrowed from someone else's debug
arsenal.  ;)

In any case, I think that sort of debug assist doesn't need to
stay in production system.  See the patch I posted previously...

- Dave
