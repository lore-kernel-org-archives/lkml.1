Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYAHHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYAHHRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 02:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbYAHHRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 02:17:22 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:60150 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbYAHHRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 02:17:22 -0500
Date: Tue, 8 Jan 2008 09:17:20 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NIC as RS232
Message-ID: <20080108071720.GB4503@mea-ext.zmailer.org>
References: <47831CC3.9080604@asyr.hopto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47831CC3.9080604@asyr.hopto.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 08:48:35AM +0200, Thanasis wrote:
> Is there a kernel driver that would make a NIC's port work as a RS232
> port, using the serial cables that are RJ45 on one side and DB9 or DB25
> on the other? Maybe null modem cables of that type ? Or for example
> those used by cisco as console port cables?
> 
> (or may be I'm dreaming ;-)

With a certain e.g. Freescale embedded communication processors that could
be possible, as those have hardware that can do serial communication in
many different bit patterns, and not being limited only on ethernets.

However even they talk parallel MII protocol to Ethernet PHY, which then
serializes the bitstream for transmit.  Speeds are standard 10 and 100
Mbit/s, and electrical signals depend on wiring standard, probably isolated
differential signals on twisted pairs.

I don't think you can use any ethernet phy hardware for anything but
ethernet frames.  Even when you send bytes over MII, they are still just
a bitstream needing MAC level processing to find correct alignments.

You can, of course, talk ethernet protocol to remote serial port servers,
but these days those systems talk TCP, which makes application programming
all that much easier.


Once upon a time I was talking to a group of telco engineers and said that
"These Telco SDH ports are one of the reasons why bit communication is
expensive.  In the future things will go to optical ethernet interface,
which is either carried over DWM lambdas for long hauls, or just dark
fibers."   Now it looks like I was right..

   /Matti Aarnio
