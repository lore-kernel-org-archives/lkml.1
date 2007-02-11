Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbXBKXoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbXBKXoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbXBKXoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:44:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbXBKXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:44:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:41:21 +0100
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <20070211215211.GB13913@1wt.eu> <1171232786.4493.62.camel@nigel.suspend2.net>
In-Reply-To: <1171232786.4493.62.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120041.22608.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 23:26, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-02-11 at 22:52 +0100, Willy Tarreau wrote:
> > On Sun, Feb 11, 2007 at 12:31:14PM -0600, Robert Hancock wrote:
> > > Willy Tarreau wrote:
> > > >Nigel, don't take it as a personal offense, but I think it is a very
> > > >centric view of Linux usages. Where I work, Linux is used a lot on
> > > >servers and appliances. It is used for mail relays, HTTP proxies,
> > > >anti-viruses, firewalls, routers, load balancers, UTM, SSH relays,
> > > >etc... Nobody would ever want to enable power management on those
> > > >machines, let alone suspend which would cause a major havoc, would
> > > >the system decide to enter suspend for any reason.
> > > >
> > > >Many people also have Linux on their notebooks, but as a dual-boot. You
> > > >read the word ? "dual-boot". It means that they cleanly shutdown their
> > > >system every time they don't use it anymore, and they won't know what
> > > >OS they'll use next time.
> > > >
> > > >I've never heard anyone there complaining "oh, I'm fed up with this
> > > >boring boot, I always have to wait 30 seconds when I need to do
> > > >something, I wish I could suspend and resume". It is considered the
> > > >normal way of using their PCs.
> > > 
> > > I think your experience is rather different than that of Joe Average 
> > > User who doesn't frequent kernel lists, and also I think you'll find 
> > > that for a lot of Linux laptop users that don't use supend, the reason 
> > > is that it doesn't work reliably, quite often due to driver issues.
> > 
> > I would believe it if I knew people using suspend/resume on the other OS.
> > But that's not the case either. Also, it happens that with today's RAM
> > sizes, suspend-to-disk then resume can be several times slower than a
> > clean fresh boot. When you have 1 GB to write at 20 MB/s, it takes 50
> > seconds to shut down, and as much to restart. Compare this to 5-10
> > seconds for a shutdown and 30-50 seconds for a cold boot, and it might
> > give you another clue why there are people not interested in such a
> > feature.
> 
> I'm using M$ hibernation and Suspend2 to dual boot on our desktop (dtv
> card that Linux doesn't support well yet), and I know other Suspend2
> users doing the same. It's made earier by the fact that Suspend2 lets
> you reboot instead of powering down.

Well, I don't know why you're saying it's a special capability of suspend2.
Even the "old" swsusp has been able to do this since I can remember. ;-)

Greetings,
Rafael
