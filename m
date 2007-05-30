Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbXE3AbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbXE3AbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 20:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXE3AbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 20:31:11 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbXE3AbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 20:31:10 -0400
Date: Tue, 29 May 2007 17:30:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] RTC: Use fallback IRQ if PNP tables don't provide one
Message-Id: <20070529173058.c003e18c.akpm@linux-foundation.org>
In-Reply-To: <pan.2007.05.28.18.50.22@free.fr>
References: <20070527190351.GA21387@srcf.ucam.org>
	<20070527233911.GA23491@srcf.ucam.org>
	<20070528003822.GA23759@srcf.ucam.org>
	<200705271844.54589.david-b@pacbell.net>
	<20070528172418.GA2076@srcf.ucam.org>
	<pan.2007.05.28.18.50.22@free.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 18:50:22 +0000 (UTC)
Matthieu CASTET <castet.matthieu@free.fr> wrote:

> Hi,
> 
> 
> On Mon, 28 May 2007 18:24:18 +0100, Matthew Garrett wrote:
> 
> > From: Matthew Garrett <mjg59@srcf.ucam.org>
> > 
> > Intel Macs (and possibly other machines) provide a PNP entry for the
> > RTC, but provide no IRQ. As a result the rtc-cmos driver doesn't allow
> > wakeup alarms. If the RTC is located at the legacy ioport range, assume
> > that it's on IRQ 8 unless the tables say otherwise.
> I post something via gmane this morning, but it seems it was lost :
> 
> Did you check if there aren't multiple configuration for rtc (one with 
> irq, and
> one without it) ?
> 
> What's the ouput of 
> $ for i in /sys/bus/pnp/devices/*; do if [ "$(cat $i/id)" = PNP0b00 ]; 
> then cat
> $i/resources; echo options; cat $i/options; fi; done
> 

Matthew didn't reply to this, almost surely because you removed him
(and David) from the cc.  Please don't ever do that.
