Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZHPHqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZHPHqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 03:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZHPHqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 03:46:13 -0400
Received: from 1wt.eu ([62.212.114.60]:44368 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZHPHqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 03:46:12 -0400
Date: Sun, 16 Aug 2009 09:40:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Tippett, Matthew" <Matthew.Tippett@amd.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
Message-ID: <20090816074008.GA11624@1wt.eu>
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com> <20090812005532.GA31003@srcf.ucam.org> <20090814163233.GC1626@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814163233.GC1626@ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 06:32:33PM +0200, Pavel Machek wrote:
> On Wed 2009-08-12 01:55:32, Matthew Garrett wrote:
> > On Tue, Aug 11, 2009 at 08:51:49PM -0400, Tippett, Matthew wrote:
> > 
> > >    From a graphics perspective (your area of expertise), this will allow KMS
> > >    drivers to do some more intelligent actions based on the ac/dc state. 
> > >    Some examples of this could be improving the power consumption of the
> > >    graphics hardware through adapting clock memory/engine settings for
> > >    reduced power consumption, reducing refresh rate of the display to reduce
> > >    scanout memory access, adjusting backlight brightness, etc.
> > 
> > Right. As you say, my concern is that most of this should belong in 
> > userspace. Where we risk hardware damage there's an obvious argument for 
> > doing this in kernel, but we should ensure that that's limited to 
> > whatever coarse-grain handling is absolutely required rather than doing 
> > things like touching display brightness.
> 
> Yep... Some may want to save power even when AC is online -- like when
> running on UPS. Some may want max performmance even on battery. 

Wholeheartly agreed. IMHO, there's absolutely no relation between power
source and the expected performance. It's really frustrating when your
laptop becomes a snail on battery, as well as it's annoying to hear it
sound like a hairdryer when plugged to mains. This should only be the
user's choice. Mine automatically adjusts its frequency on demand,
regardless of the power source, which provides me with the best
experience. I think that all the tricks used to save power when running
on battery were invented by laptop makers to artificially show longer
lasting eventhough the machine sometimes becomes barely usable. For
instance, some of them dim the backlight so that you can't read anything
in full light, so you need a power prolongator to use them outside !

Also, with the new trend of laptops making use of huge power-hungry 3D
graphic chips which suck all the juice out of your battery in less than
two hours doing nothing, you'd better run at full speed when on battery
to save energy for CPU-bound tasks, because eventhough the CPU eats more
power, you significantly reduce the run time, thus the static consumption
(GPU, backlight, hard disk, ...).

Willy

