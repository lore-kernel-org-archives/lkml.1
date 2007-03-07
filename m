Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbXCGGZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbXCGGZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbXCGGZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:25:18 -0500
Received: from 1wt.eu ([62.212.114.60]:4989 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbXCGGZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:25:16 -0500
Date: Wed, 7 Mar 2007 07:21:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
Message-ID: <20070307062157.GJ943@1wt.eu>
References: <20070305014956.GE3441@stusta.de> <45EDA8EE.1060308@tmr.com> <20070306175504.GW3441@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306175504.GW3441@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 06:55:04PM +0100, Adrian Bunk wrote:
> On Tue, Mar 06, 2007 at 12:46:22PM -0500, Bill Davidsen wrote:
> > Adrian Bunk wrote:
> > >This patch contains the scheduled removal of the OBSOLETE_OSS options 
> > >for 2.6.22.
> > >
> > If these are drivers for which there are thought to be useful ALSA 
> > drivers, would it be reasonable to leave a stub for a help file naming 
> > the driver which claims to support the hardware?
> > 
> > I'm not objection to the removal of the drivers, just noting that 
> > identifying the new drivers can be made easier.
> 
> People compiling their own kernels aren't completely dumb - if you know 
> about people having problems finding the right ALSA driver for their 
> hardware, please name the concrete problems so that we can improve the 
> description and/or help text of these ALSA options.

Real problem is that we can expect several "sound does not work anymore"
because people doing "make oldconfig" will get no warning at all about
the removed options. Remember people complaining about keyboard not working ?
Perhaps the real problem is more Kconfig than OSS, but it would be fine if
we found a solution to enumerate the list of options which have been removed
when they do their make oldconfig.

Regards,
Willy

