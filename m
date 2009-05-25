Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZEYXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZEYXiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZEYXiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:38:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZEYXiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:38:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA, Gigabyte EG45M-DS2H
Date: Tue, 26 May 2009 01:38:12 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Richard Atterer <richard@2009.atterer.net>, linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <200905260111.40728.rjw@sisk.pl> <200905260119.57542.bzolnier@gmail.com>
In-Reply-To: <200905260119.57542.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260138.12880.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 26 May 2009 01:11:40 Rafael J. Wysocki wrote:
> > On Monday 25 May 2009, Richard Atterer wrote:
> > > On Mon, May 25, 2009 at 04:30:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > Hmm, we added ACPI NVS memory handling there and some machines seem
> > > > to have trouble with it.  I think it would be worth to check it first.
> > > > 
> > > > Richard, could you try s2disk on some recent 2.6.30-rc kernel while
> > > > booting using "acpi_sleep=s4_nonvs"?
> > > 
> > > I just tried that with 2.6.30-rc7, unfortunately it doesn't make any 
> > > difference.
> > > 
> > > It turns out that if I wait long enough (just over 1 minute) both during 
> > > suspend and resume, I *am* able to suspend and resume the machine. I have 
> > > to manually turn it off or reset it though.
> > > 
> > > Another possibly interesting observation: My DVD writer apparently gets 
> > > reset before the 1-minute hang and my USB hub after the hang.
> > 
> > You replied to Jeff that hibernation worked with CONFIG_IDE=n.  What was wrong
> > with that test?
> 
> It didn't work.  That was wrong.
> 
> Please at least read the current thread before asking such questions.

Sorry, I was wondering why Richard told Jeff that the test worked at that time.

I should have asked differently or something, perhaps.

Best,
Rafael
