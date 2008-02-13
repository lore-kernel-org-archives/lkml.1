Return-Path: <linux-kernel-owner+w=401wt.eu-S1763506AbYBMPHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763506AbYBMPHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYBMPHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:07:32 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:44305 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbYBMPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:07:31 -0500
Date: Wed, 13 Feb 2008 10:07:27 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Josh Boyer <jwboyer@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk
Subject: Re: latest list of unused Kconfig variables
In-Reply-To: <20080213073242.5c069c25@zod.rchland.ibm.com>
Message-ID: <alpine.LFD.1.00.0802131002310.28617@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain> <20080213073242.5c069c25@zod.rchland.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Josh Boyer wrote:

> On Wed, 13 Feb 2008 03:56:34 -0500 (EST)
> "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> >   now that 2.6.25-rc1 is out, i can start updating the output from
> > my scanning scripts.  the first updated output is the list of
> > currently unused Kconfig variables -- variables that are defined
> > in some Kconfig file somewhere but appear to be entirely unused
> > throughout the source tree.
> >
> >   latest output here, sorted by architecture:
> >
> > http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables
> >
> > as always, there will probably be some false positives for one
> > reason or another.
> >
> >   output from the other scanning scripts will be up in short order.
>
> You have lots of false positives (or something) for arch/powerpc.
> Seems your script picked up #define names and comments that happen
> to match a Kconfig variable?

it always will, given the proclivity of some folks to define their own
variables with a "CONFIG_" prefix.  as i point out on the wiki page, i
make no attempt to cull that list, i just print it as is, and readers
will have to peruse the list carefully to see what's meaningful and
what isn't.

> And you have false positives on several CPU variables, as they are
> used within Kconfig files themselves to select different sets of
> options.

yes, i know ... perhaps there's a simple way to filter those out but,
at the moment, it's pure brute force.  i'm guessing i could make that
script a bit smarter but it probably isn't worth the investment in
time.  law of diminishing returns and all that.

> For arch/ppc, the WANT_EARLY_SERIAL stuff was added by Al to fix those
> boards that unconditionally called early_serial_setup by selecting
> SERIAL_8250 in commit f08243a491f3e21feabbb04476a03fb0cbc975ff.  Al,
> couldn't we just select SERIAL_8250 right in the board config
> instead?
>
> Of course, arch/ppc is dying soon-ish anyway so we might not even
> bother.

if that's the case, i can just stop scanning that entire directory.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
