Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196Ab0ARAgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0ARAgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515Ab0ARAgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:36:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab0ARAga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:36:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: Regression: Wake on LAN doesn't work in sky2 with 2.6.33-rc4-git2
Date: Mon, 18 Jan 2010 01:36:45 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
References: <20100115091053.GA5477@mac.home> <201001152323.37718.rjw@sisk.pl> <20100117231932.GA5504@mac.home>
In-Reply-To: <20100117231932.GA5504@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001180136.45823.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, Tino Keitel wrote:
> On Fri, Jan 15, 2010 at 23:23:37 +0100, Rafael J. Wysocki wrote:
> > On Friday 15 January 2010, Stephen Hemminger wrote:
> 
> [...]
> 
> > > This has already been reported.
> > > 
> > > Rafael has been doing the generic PM stuff.
> > > Look for thread,
> > >  [Bug 14730] sky2 won't work after suspend/resume cycle
> > 
> > This has been fixed already and the bug appears to be different.
> 
> Yes, sounds different. The interface works after a resume. My issue is
> that the computer just won't resume at all using wake on LAN.
> 
> > 
> > No idea what it is at the moment.
> > 
> > Tino, please check if reverting commit
> > dc1a94ae1749d14c55f8b54e9d92bd89df82d51a helps, although the messages
> > indicate that the generic PCI-side does its job.
> 
> No luck with the commit reverted, WoL still doesn't work.

Well, this commit is the only PCI core change affecting WoL after 2.6.32 IIRC.

Rafael
