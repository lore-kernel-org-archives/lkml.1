Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbZAMOHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbZAMOHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760957AbZAMOGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:06:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760953AbZAMOGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:06:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Date: Tue, 13 Jan 2009 15:06:01 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, harvey.harrison@gmail.com
References: <20090113081316.GA2292@elf.ucw.cz> <200901131239.21995.rjw@sisk.pl> <20090113130536.GB30352@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090113130536.GB30352@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131506.01602.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009, Pavel Machek wrote:
> 
> > On Tuesday 13 January 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > Just when I thought long merge window means less problems...
> > > 
> > > ...suspend seemed to work until last tuesday or so. Now it hanged two
> > > times; once so hard that power button powercycle did not result in
> > > booting machine. (thinkpad x60)
> > > 
> > > I'll do some more tests...
> > 
> > There are a couple of things you may want to revert, like
> > 7503bfbae89eba07b46441a5d1594647f6b8ab7d and
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .
> > 
> > Please let me know if that helped.
> 
> Harwey told me they are already reverted in latest -git, so I tried
> that but no luck. I'll try disabling CONFIG_SMP now.
> 
> Actually, in one case I seen some oopses scroll by... looked
> timekeeping related, but certainly went too fast.

Hm, I'm unable to reproduce this on my test boxes.

What hardware is there in your machine?

Rafael
