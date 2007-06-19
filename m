Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbXFSFme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbXFSFme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbXFSFmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:42:16 -0400
Received: from mx2.go2.pl ([193.17.41.42]:57253 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759882AbXFSFmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:42:14 -0400
Date: Tue, 19 Jun 2007 07:50:07 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070619055007.GB1649@ff.dom.local>
References: <4bacf17f0706161435g1bb7c08bpd427901f64d57fa@mail.gmail.com> <20070618110849.GA2450@ff.dom.local> <20070618081000.14da5186@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618081000.14da5186@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:10:00AM -0700, Stephen Hemminger wrote:
> On Mon, 18 Jun 2007 13:08:49 +0200
> Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > On 16-06-2007 23:35, Marcin .lusarz wrote:
> > > hi
> > > after upgrading kernel from 2.6.20 to 2.6.21.3 i'm experiencing really
> > > strange problem - my _both_ network cards dies after random uptime -
> > > sometimes it's a few minutes, sometimes hours, sometimes it does not
> > > happen for a couple of days...
> > > today it happened for the first time without nvidia module and almost
> > > immediately after system start
> > > 
> > > here is the output of some commands which might help debug this:
...
> > It looks like skge driver enables different device than probbed.
> > Maybe you've something old/wrong about eth0/eth1 in /etc configs?
> 
> More likely it is just user level device renaming. Most distro's
> rename devices (if needed) using udev.

On the other hand it's interesting, why it's not always, and why
sometimes it took so long?

Jarek P. 
