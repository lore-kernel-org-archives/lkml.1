Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYAGVgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYAGVgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYAGVfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:35:55 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59237 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYAGVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:35:54 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 7 Jan 2008 13:35:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Christian Kujau <lists@nerdbynature.de>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Johannes Berg <johannes@sipsolutions.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.24-rc6: possible recursive locking detected
In-Reply-To: <alpine.DEB.0.999999.0801060118290.4821@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.64.0801071334340.2508@alien.or.mcafeemobile.com>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de> 
 <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu> 
 <20080105071205.GA28936@gondor.apana.org.au>  <1199552016.31975.41.camel@lappy>
 <1199552476.31975.45.camel@lappy> <Pine.LNX.4.64.0801051242070.3896@alien.or.mcafeemobile.com>
 <alpine.DEB.0.999999.0801060118290.4821@sheep.housecafe.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Christian Kujau wrote:

> On Sat, 5 Jan 2008, Davide Libenzi wrote:
> > A solution may be to move the call to ep_poll_safewake() (that'd become a
> > simple wake_up()) inside a tasklet or whatever is today trendy for delayed
> > work. But his kinda scares me to be honest, since epoll has already a
> > bunch of places where it could be asynchronously hit (plus performance
> > regression will need to be verified).
> 
> Although I'm not able to reproduce this one right now, I'm happy to test any
> patches you guys come up with.

There's no need to reproduce it. It's there, it's among us ;)



- Davide


