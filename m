Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbXH0V5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbXH0V5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXH0VtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:49:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764743AbXH0VtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:49:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Date: Mon, 27 Aug 2007 23:59:31 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, rusty@rustycorp.com.au,
       vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070827104350.GA2073@elf.ucw.cz> <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com> <20070827213248.GF3398@elf.ucw.cz>
In-Reply-To: <20070827213248.GF3398@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708272359.32484.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 August 2007 23:32, Pavel Machek wrote:
> On Mon 2007-08-27 22:36:57, Jeff Chua wrote:
> > On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > > > Hi!
> > > >
> > > > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > > > x60, i386 architecture).
> > 
> > I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
> > and my system still survives.
> 
> Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> so cycles at one point.
> 
> ...or maybe difference is in the .config, or maybe I broken something
> in my kernel sources....

Well, something seems to be wrong with the CPU hotplug, but it's insanely
difficult to reproduce on my boxes.

I bet on one of the notifiers blocking while waiting on a frozen task.

Greetings,
Rafael
