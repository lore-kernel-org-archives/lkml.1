Return-Path: <linux-kernel-owner+w=401wt.eu-S1765625AbYBMPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765625AbYBMPcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYBMPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:32:44 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45556 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYBMPcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:32:43 -0500
Date: Wed, 13 Feb 2008 10:32:35 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Josh Boyer <jwboyer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk
Subject: Re: latest list of unused Kconfig variables
In-Reply-To: <20080213151628.GA10915@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.00.0802131031040.30876@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain> <20080213073242.5c069c25@zod.rchland.ibm.com> <alpine.LFD.1.00.0802131002310.28617@localhost.localdomain> <20080213151628.GA10915@uranus.ravnborg.org>
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

On Wed, 13 Feb 2008, Sam Ravnborg wrote:

> On Wed, Feb 13, 2008 at 10:07:27AM -0500, Robert P. J. Day wrote:
> > On Wed, 13 Feb 2008, Josh Boyer wrote:
> >
> > > On Wed, 13 Feb 2008 03:56:34 -0500 (EST)
> > > "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> >
> > > >   now that 2.6.25-rc1 is out, i can start updating the output from
> > > > my scanning scripts.  the first updated output is the list of
> > > > currently unused Kconfig variables -- variables that are defined
> > > > in some Kconfig file somewhere but appear to be entirely unused
> > > > throughout the source tree.
> > > >
> > > >   latest output here, sorted by architecture:
> > > >
> > > > http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables
> > > >
> > > > as always, there will probably be some false positives for one
> > > > reason or another.
> > > >
> > > >   output from the other scanning scripts will be up in short order.
> > >
> > > You have lots of false positives (or something) for arch/powerpc.
> > > Seems your script picked up #define names and comments that happen
> > > to match a Kconfig variable?
> >
> > it always will, given the proclivity of some folks to define their own
> > variables with a "CONFIG_" prefix.  as i point out on the wiki page, i
> > make no attempt to cull that list, i just print it as is, and readers
> > will have to peruse the list carefully to see what's meaningful and
> > what isn't.
>
> CONFIG_* should in the kernel be assumed a reserved namespace for
> kconifg. So any use of variables/defines named CONFIG_* which is not
> a kconfig symbol is a bug.

heh ... good luck with *that*:

$ grep -r "^#define CONFIG_" * | wc -l
752
$

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
