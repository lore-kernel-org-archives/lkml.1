Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXEWQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXEWQwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbXEWQwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:52:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494AbXEWQwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:52:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Romano Giannetti <romano.giannetti@gmail.com>
Subject: Re: 2.6.21.1 fails to suspend/resume  to disk  (sort of)
Date: Wed, 23 May 2007 18:57:32 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <1179905115.7043.25.camel@localhost> <200705231105.08408.rjw@sisk.pl> <1179914262.7043.56.camel@localhost>
In-Reply-To: <1179914262.7043.56.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231857.33012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 23 May 2007 11:57, Romano Giannetti wrote:
> On Wed, 2007-05-23 at 11:05 +0200, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Wednesday, 23 May 2007 09:25, Romano Giannetti wrote:
> > > http://lkml.org/lkml/2007/5/23/38
> > 
> > Please see http://bugzilla.kernel.org/show_bug.cgi?id=8456
> > That seems to resemble the symptoms you describe.
> > 
> 
> No, I don't think. The delay I observe is on resume (suspend is very
> fast). Moreover, I have no SATA. It seems that my problem came from
> pcmcia.

Hmm, there also is this patch: http://lkml.org/lkml/2007/5/22/434

> > > Now for the suspend to disk. With default setting (/sys/power/disk ==
> > > platform) my laptop (vaio PGC-FX701) fails to poweroff; it stays with
> > > backlight on, a white screen, and if I power it off manually afterward
> > > it did not resume.
> > > 
> > > By doing echo shutdown > /sys/power/disk the laptop *do* power off (it's
> > > very slow, but I think that's related with the 60 secs delay commented
> > > in the other post). Then it resume --- text console did resume ok ---
> > > but the virtual console with X do not come back. I had to do a
> > > ctrl-alt-backspace thing. 
> > > 
> > > Any hints? More data?
> > 
> > Could you please test the 2.6.22-rc2 kernel?  Also, if it still doesn't work
> > properly, could you apply the hibernation/suspend patchset available from
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc2/patches
> > on top of it and see if that helps?
> > 
> 
> Uf, I will try to find the time. I am on my way to try to compile
> 2.6.21.2 now. Problem is that a kernel compile "the ubuntu way" last
> hours here. If there is an expert on make-kpkg here, I could use some
> advise. I'd prefer to test patches over a 2.6.21 stable release, to
> avoid mixing symptoms from an experimental -rc...

OK, I'll try to see which ones apply on top of 2.6.21 cleanly.

Greetings,
Rafael
