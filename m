Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXCTU4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXCTU4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXCTU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:56:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbXCTU4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:56:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] 2.6.21-rc4-mm1
Date: Tue, 20 Mar 2007 21:58:48 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pm@lists.osdl.org,
       linux-kernel@vger.kernel.org
References: <20070319205623.299d0378.akpm@linux-foundation.org> <46004080.6080202@gmail.com> <20070320202141.GA3604@elf.ucw.cz>
In-Reply-To: <20070320202141.GA3604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202158.50063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 21:21, Pavel Machek wrote:
> Hi!
> 
> > >>>> Also, it might be useful to add a temporary /proc/freeze-unfreeze thing
> > >>>> which will simply do a freeze/unfreeze cycle.  Then we can apply various
> > >>>> workloads to the machine while madly stressing the freezer code.  
> > >>> echo testproc > /sys/power/disk; echo disk > /sys/power/state ... is
> > >>> pretty much what you want.
> > >> Ok, I'll try this.
> > > 
> > > It will not help you -- probably -- it is equivalent to just running
> > > s2ram. But it should make "successful" testing easier, because you no
> > > longer need machine with working suspend to test refrigerator.
> > 
> > Aha, I didn't read it carefully. Suspend is working, but not in this kernel.
> > I haven't tried s2ram in this version. Should I (I'm away from it) -- would
> > it show something?
> 
> No, probably not. git bisect would help, but I guess it is easier to
> let Rafael sort it out.

Actually, the problem is 100% reproducible on my system too and I doubt it's
caused by the recent freezer patches.

Investigating.

Rafael
