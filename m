Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbXBKXTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbXBKXTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXBKXTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:19:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563AbXBKXTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:19:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 00:16:17 +0100
User-Agent: KMail/1.9.5
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <20070211210258.0b8da53c@localhost.localdomain> <1171235428.4493.105.camel@nigel.suspend2.net>
In-Reply-To: <1171235428.4493.105.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120016.18480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 00:10, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-02-11 at 21:02 +0000, Alan wrote:
> > > > "If the device requires that, implement .suspend and .resume or at least
> > > > define .suspend that will always return -ENOSYS (then people will know they
> > > > have to unload the driver before the suspend).  Similarly, if you aren't sure
> > > > whether or not the device requires .suspend and .resume, define .suspend that
> > > > will always return -ENOSYS."
> > > 
> > > Sounds ok to me. Where should this text go?
> > > Documentation/SubmittingDrivers ?
> > 
> > And testing/submitting drivers, perhaps with additional text in that to
> > make it clear we want suspend/resume support or good excuses
> > 
> > "Please verify your driver correctly handles suspend and resume. If it
> > does not your patch submission is likely to be suspended and only resume
> > when the driver correctly handles this feature"
> 
> Maybe make it explicit that testing should be done for both suspend to
> ram and to disk, and with the following usage scenarios as applicable?
> 
> - built in;
> - modular, loaded while suspending but not loaded prior to resume from
> disk;
> - modular, loaded while suspending and loaded prior to resume from disk;

I think we should state the general rule in Documentation/SubmittingDrivers
and give more details in Documentation/power/devices.txt

Greetings,
Rafael
