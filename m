Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXIQTlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXIQTlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbXIQTlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:41:45 -0400
Received: from outbound-mail-78.bluehost.com ([69.89.22.27]:40619 "HELO
	outbound-mail-78.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753766AbXIQTlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:41:44 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Lossy interrupts on x86_64
Date: Mon, 17 Sep 2007 12:40:54 -0700
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
References: <200709120833.15980.jbarnes@virtuousgeek.org> <200709171213.21511.jbarnes@virtuousgeek.org> <1190056703.2995.11.camel@chaos>
In-Reply-To: <1190056703.2995.11.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709171240.55260.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.88.206.99 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2007, Thomas Gleixner wrote:
> On Mon, 2007-09-17 at 12:13 -0700, Jesse Barnes wrote:
> > On Wednesday, September 12, 2007, Thomas Gleixner wrote:
> > > does it make any difference when you boot the box with:
> > >
> > > nohz=off
> > >
> > > on the kernel command line ?
> >
> > Yeah, that makes a difference:  the box hangs when I start
> > receiving vblank interrupts instead.  However it's not a hard hang,
> > I think X just becomes unresponsive.  I can still hit the power
> > button on the laptop and the machine shuts down gracefully, but
> > ctl-alt-delete and ctl-alt-backspace don't work.  So X is probably
> > still up and in charge of input but may not be getting any more
> > timeslices or something.
>
> Eeek, that sounds scary. Can you add "highres=off" as well ?

with nohz=off and highres=off I get a similar but not quite identical 
hang:  the mouse pointer still moves around but my desktop is still 
hung and glxgears doesn't come up.  Behavior is identical without boot 
options and with highres=off however (i.e. lossy interrupts in both 
cases).

Jesse
