Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZFHLad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZFHLad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZFHLaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:30:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZFHLaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:30:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Mon, 8 Jun 2009 13:30:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu>
In-Reply-To: <20090608065419.GA13568@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081330.50045.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > +config PM_RUNTIME
> > +	bool "Run-time PM core functionality"
> > +	depends on PM
> > +	---help---
> > +	  Enable functionality allowing I/O devices to be put into energy-saving
> > +	  (low power) states at run time (or autosuspended) after a specified
> > +	  period of inactivity and woken up in response to a hardware-generated
> > +	  wake-up event or a driver's request.
> > +
> > +	  Hardware support is generally required for this functionality to work
> > +	  and the bus type drivers of the buses the devices are on are
> > +	  responsibile for the actual handling of the autosuspend requests and
> > +	  wake-up events.
> 
> Halleluya! :-)

I guess this means you like the general idea. ;-)

Well, we've been discussing it for quite a while and since more and more people
are interested, I'm giving it a high priority.

Best,
Rafael
