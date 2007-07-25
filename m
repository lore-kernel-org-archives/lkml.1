Return-Path: <linux-kernel-owner+w=401wt.eu-S935778AbXGYTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778AbXGYTVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933770AbXGYTVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:21:15 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33825 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762003AbXGYTVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:21:14 -0400
Subject: Re: MMC/SD Root filesystem suspend/resume problems
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070725190115.GB10208@ucw.cz>
References: <1184860419.29634.10.camel@localhost.localdomain>
	 <20070719190309.28708be8@poseidon.drzeus.cx>
	 <1185110313.6819.8.camel@localhost.localdomain>
	 <20070725190115.GB10208@ucw.cz>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 20:20:42 +0100
Message-Id: <1185391242.6190.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 19:01 +0000, Pavel Machek wrote:
> > I enabled the MMC_UNSAFE_RESUME option and the problems I was seeing was
> > "fixed". I think having this option is a bad idea (in its current form)
> > as it doesn't actually stop filesystem corruption.
> > 
> > With the option disabled, if a filesystem is mounted when you suspend my
> > tests show the filesystem is corrupted. At least if the option is
> > enabled, the filesystem is only corrupted if you remove the card whilst
> > suspended which is more preferable.
> 
> Are we talking _corruption_ here, or are we talking 'the kind of
> corruption recoverable by fsck that happens on powerfail'?

There was more damage to the system than just a dirty bit set. Yes, fsck
could fix it but I don't think it should happen in the first place...

Richard

