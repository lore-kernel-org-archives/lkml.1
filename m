Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbXCSVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbXCSVUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXCSVUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:20:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbXCSVUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:20:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Date: Mon, 19 Mar 2007 22:23:29 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Ingo Molnar <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <b6a2187b0703060412l66fe8db8l12e5403821d1438b@mail.gmail.com> <20070319153222.GF1915@elf.ucw.cz>
In-Reply-To: <20070319153222.GF1915@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703192223.31222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 March 2007 16:32, Pavel Machek wrote:
> 
> > >> > > > I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> > >> > > > from RAM, can't suspend to disk. It is possible to revert all the
> > >> > > > changes to ACPI and test it?
> > >> > >
> > >> > > This is with CONFIG_KVM=n?
> > >> >
> > >> > Yes.
> > >>
> > >> I've tried with CONFIG_KVM=n and CONFIG_KVM=y and both does not suspend.
> > >
> > >Do you mean that they "do not resume after suspend"?
> > 
> > I can't even suspend to disk/ram. It just hangs and the lights just
> > blink and everything else hangs. With 2.6.20, it works fine.
> 
> Turn up console loglevel, and see where it hangs...

I think CONFIG_DISABLE_CONSOLE_SUSPEND would have to be set for this purpose
too.

Greetings,
Rafael
