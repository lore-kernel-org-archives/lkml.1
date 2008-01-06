Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYAFAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYAFAUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYAFAUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:20:34 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:46444 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYAFAUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:20:34 -0500
Date: Sun, 6 Jan 2008 01:20:17 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Davide Libenzi <davidel@xmailserver.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Johannes Berg <johannes@sipsolutions.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.24-rc6: possible recursive locking detected
In-Reply-To: <Pine.LNX.4.64.0801051242070.3896@alien.or.mcafeemobile.com>
Message-ID: <alpine.DEB.0.999999.0801060118290.4821@sheep.housecafe.de>
References: <alpine.DEB.0.999999.0801032349190.4821@sheep.housecafe.de>  <200801040006.47979.rjw@sisk.pl> <20080104083049.GC22803@elte.hu>  <20080105071205.GA28936@gondor.apana.org.au>  <1199552016.31975.41.camel@lappy> <1199552476.31975.45.camel@lappy>
 <Pine.LNX.4.64.0801051242070.3896@alien.or.mcafeemobile.com>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Davide Libenzi wrote:
> A solution may be to move the call to ep_poll_safewake() (that'd become a
> simple wake_up()) inside a tasklet or whatever is today trendy for delayed
> work. But his kinda scares me to be honest, since epoll has already a
> bunch of places where it could be asynchronously hit (plus performance
> regression will need to be verified).

Although I'm not able to reproduce this one right now, I'm happy to test 
any patches you guys come up with.

Thanks for your time,
Christian.
-- 
BOFH excuse #78:

Yes, yes, its called a design limitation
