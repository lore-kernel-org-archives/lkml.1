Return-Path: <linux-kernel-owner+w=401wt.eu-S939456AbXFHVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939456AbXFHVno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbXFHVne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:43:34 -0400
Received: from pat.uio.no ([129.240.10.15]:58066 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbXFHVnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:43:33 -0400
Subject: Re: networking busted in current -git ???
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Florin Iucha <florin@iucha.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <200706082307.45722.arekm@maven.pl>
References: <20070608205640.GI30661@iucha.net>
	 <200706082307.45722.arekm@maven.pl>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 17:43:27 -0400
Message-Id: <1181339007.6675.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.4, required=12.0, autolearn=disabled, AWL=-0.405,HOT_NASTY=0.809)
X-UiO-Scanned: DD9DFFCBAEC64F3002C25D8E40C284114081173B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 4 maxlevel 200 minaction 2 bait 0 mail/h: 295 total 2268437 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 23:07 +0200, Arkadiusz Miskiewicz wrote:
> On Friday 08 of June 2007, you wrote:
> > Hello,
> >
> > I am using the current git tree: 85f6038f2170e3335dda09c3dfb0f83110e87019 .
> > Git tree from two days ago (with the same config) works fine.
> >
> > Attempting to acquire an IP address via DHCP fails with:
> >
> > SIOCSIFADDR: No buffer space available
> > Listening on LPF/eth0/00:19:b9:0c:9a:43
> > Sending on   LPF/eth0/00:19:b9:0c:9a:43
> > Sending on   Socket/fallback
> > DHCPREQUEST on eth0 to 255.255.255.255 port 67
> > DHCPACK from xxx.xxx.xxx.xxx
> > SIOCSIFADDR: No buffer space available
> > SIOCSIFNETMASK: Cannot assign requested address
> > SIOCSIFBRDADDR: Cannot assign requested address
> > SIOCADDRT: Network is unreachable
> > bound to xxx.xxx.xxx.xxx -- renewal in 98610 seconds.
> >
> > This is on a Dell 490 with tg3 network driver running Ubuntu 7.04 .
> > .config and dmesg are appended.
> >
> > florin
> 
> Here it requires few retries (stop dhcpcd, start again) to get the IP. git 
> tree from few hours ago. tg3 driver. I also saw SIOCSIFADDR: No buffer space 
> available once.

(added netdev to the Cc list)

It is not dhcp. I'm seeing the same bug with bog-standard ifup with a
static address on an FC-6 machine.

It appears to be something in the latest dump from davem to Linus, but I
haven't yet had time to identify what.

Cheers
  Trond

