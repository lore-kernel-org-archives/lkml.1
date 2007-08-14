Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbXHNStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbXHNStS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761784AbXHNStH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:49:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765342AbXHNStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:49:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: + serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch added to -mm tree
Date: Tue, 14 Aug 2007 20:58:37 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <200708092026.l79KQlDX017864@imap1.linux-foundation.org> <200708142023.23994.rjw@sisk.pl> <20070814144452.bab796b4.dilinger@queued.net>
In-Reply-To: <20070814144452.bab796b4.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708142058.38314.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 14 August 2007 20:44, Andres Salomon wrote:
> On Tue, 14 Aug 2007 20:23:23 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, 14 August 2007 12:39, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Thanks, updated below!
> > > > 
> > > > 
> > > > 
> > > > serial: turn serial console suspend a boot rather than compile time option
> > > > 
> > > > From: Andres Salomon <dilinger@debian.org>
> > > > 
> > > > Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
> > > > the serial console from being suspended when the rest of the machine goes
> > > > to sleep.  This is incredibly useful for debugging power
> > > > management-related
> > > 
> > > Actually, this should not be configurable. We should simply enable
> > > console during suspend for consoles that can handle this,
> > > automatically.... this patch does just that. I hope I separated it
> > > correctly.
> 
> 
> I disagree.  I expect that this will break things; I would prefer to keep
> it as a configuration option.  If you want to enable it by default, that's
> one thing; but give users the option to turn it off.

Hm, I think this can be combined with your patch:

(1) add a command line parameter that will turn the suspending of consoles on
(2) add a switch that will disable the thing regardless of (1) if netconsole is
    enabled (like in the Pavel's patch).

Greetings,
Rafael
