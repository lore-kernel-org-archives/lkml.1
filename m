Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYHCTtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYHCTtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 15:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYHCTsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 15:48:52 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:58267 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYHCTsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 15:48:51 -0400
Date: Sun, 3 Aug 2008 21:48:21 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "Denis V. Lunev" <den@openvz.org>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: oops in rt_cache_invalidate (2.6.27-rc1-2b12a4c)
In-Reply-To: <alpine.LNX.1.10.0808032141010.29048@titan.stealer.net>
Message-ID: <alpine.LNX.1.10.0808032145550.29048@titan.stealer.net>
References: <20080803170241.GD5414@joi> <1217789775.8154.34.camel@iris.sw.ru> <alpine.LNX.1.10.0808032110520.7765@titan.stealer.net> <alpine.LNX.1.10.0808032141010.29048@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -1.0
X-Spam-Bar: -
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 03 Aug 2008 19:48:50 +0000
	Bayes: 0.0492 Tokens: new, 158; hammy, 3; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0492]
X-Spam-Signature: ba045ace9350a0de1207fef64ef2f93d34793f08
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Sven Wegener wrote:

> On Sun, 3 Aug 2008, Sven Wegener wrote:
> 
> > On Sun, 3 Aug 2008, Denis V. Lunev wrote:
> > 
> > > On Sun, 2008-08-03 at 19:02 +0200, Marcin Slusarz wrote:
> > > > [...]
> > > > It's 2b12a4c524812fb3f6ee590a02e65b95c8c32229 + some unreleated trivial patches.
> > > 
> > > Could you send you .config?
> > 
> > No need to, the issue can be triggered by
> > 
> > sysctl net.ipv4.ip_default_ttl=1
> > 
> > when 76e6ebfb40a2455c18234dcb0f9df37533215461 is applied.
> 
> Actually it's 86c657f6b5bbf2f3ec2213eca528998134a9b344, 76e6ebf adds the 
> initial code that accesses the extra2 parameter, but 86c657f adds the 
> oops.

I should stop for today, it's e84f84f276473dcc673f360e8ff3203148bdf0e2 
that has the &net->ipv4.rt_genid in rt_cache_invalidate(). ...
