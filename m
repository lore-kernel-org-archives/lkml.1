Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYJXHGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYJXHGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJXHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:06:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYJXHGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:06:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>,
       Nico Schottelius <nico-linux-next@schottelius.org>
Subject: Re: Current suspend issues on Lenovo X200 (w/ Intel graphics)
Date: Fri, 24 Oct 2008 09:11:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810240006.19857.rjw@sisk.pl> <1224817394.6623.12.camel@nigel-laptop>
In-Reply-To: <1224817394.6623.12.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810240911.05193.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, Nigel Cunningham wrote:
> Hey Rafael :)
> 
> On Fri, 2008-10-24 at 00:06 +0200, Rafael J. Wysocki wrote:
> > On Thursday, 23 of October 2008, Nico Schottelius wrote:
> > > First of all, this was wrong:
> > > 
> > > Nico -telmich- Schottelius [Thu, Oct 23, 2008 at 10:43:26PM +0200]:
> > > >  - 2.6.27: system freeze instead of wakeup
> > > >    -> shows parts of the X screen, but does not react on ping
> > > 
> > > System does not freeze, but reboots instead.
> > > 
> > > Tried next-20081023 and 2.6.27 with acpi_sleep=s3_bios:
> > > 
> > > - suspend and wakeup on console works fine for both!
> > > - no X running on next
> > > - 2.6.27 + X -> reboot on wakeup
> > 
> > Let me guess, you have a NVidia graphics?
> 
> Not this time. Going off the other log he posted, it's...
> 
> Chipset Mobile Intel® GM45 Express Chipset found

This is going to be interesting. :-)

Nico, if the system is 64-bit, I'd recommend trying .28-rc1.

Thanks,
Rafael
