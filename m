Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbYBMPot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbYBMPot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbYBMPof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:44:35 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45945 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbYBMPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:44:33 -0500
Date: Wed, 13 Feb 2008 10:44:27 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Josh Boyer <jwboyer@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: latest list of unused Kconfig variables
In-Reply-To: <20080213093314.3220e29d@zod.rchland.ibm.com>
Message-ID: <alpine.LFD.1.00.0802131038130.30959@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain> <20080213073242.5c069c25@zod.rchland.ibm.com> <alpine.LFD.1.00.0802131002310.28617@localhost.localdomain> <20080213093314.3220e29d@zod.rchland.ibm.com>
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

> OK.  Well all of your hits for 405EX, 440GRX, 440SPe, and
> WANT_DEVICE_TREE in arch/powerpc seem bogus.  I dunno if you prune
> those when reported or not.

not normally, but i don't know what you mean by "bogus":

  $ grep -r "config 405EX" *
  arch/powerpc/platforms/40x/Kconfig:config 405EX
  $

  $ grep -r CONFIG_405EX *
  arch/powerpc/configs/makalu_defconfig:CONFIG_405EX=y
  arch/powerpc/configs/kilauea_defconfig:CONFIG_405EX=y
  $

so, AFAICT, there exists a definition of the Kconfig variable 405EX,
which is subsequently not referenced *anywhere* in the tree except in
a couple defconfig files, which don't count.  how, then, does that
Kconfig variable have any practical value?  or am i missing something
painfully obvious?

> > > And you have false positives on several CPU variables, as they
> > > are used within Kconfig files themselves to select different
> > > sets of options.
> >
> > yes, i know ... perhaps there's a simple way to filter those out
> > but, at the moment, it's pure brute force.  i'm guessing i could
> > make that script a bit smarter but it probably isn't worth the
> > investment in time.  law of diminishing returns and all that.
>
> Maybe.  If the same false positives keep showing up people might
> ignore it.  I won't, but others might.

fair enough, but since this scanning happens only once every release,
it's not like it's a burden.  and if people want to ignore it, that's
fine, too.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
