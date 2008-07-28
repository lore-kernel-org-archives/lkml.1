Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYG1Soe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYG1Soe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYG1So0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:44:26 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60249 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYG1SoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:44:25 -0400
Date: Mon, 28 Jul 2008 14:42:47 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
In-Reply-To: <20080728103731.7bafd577.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807281437070.10586@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain> <20080726094718.b617c1e7.randy.dunlap@oracle.com> <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain> <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
 <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain> <20080728103731.7bafd577.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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

On Mon, 28 Jul 2008, Randy Dunlap wrote:

> >   yes, it's nitpicking but, as it's laid out right now, it's
> > unnecessarily confusing and inconsistent.  but i don't know if
> > there's a trivial fix for it.
>
> Yes, I'd call MSDOS partitions basic, not Advanced, and then put all
> others under an Advanced menu that can be toggled on/off easily with
> menuconfig.
>
> Not quite trivial, but not messy either.
>
> Patch below.  Comments?

... patch snipped ...

  i suspect that's as good as it's going to get, but it's unfortunate
that it adds yet another level of submenu under "Partition types."
personally, i was pondering a top level submenu entry of "Advanced
partition types" in which the (non-advanced) MSDOS partition support
was yanked out of there *entirely*.

  it strikes me that, at least on x86, MSDOS partition support is so
fundamental that it should take work for someone to turn it *off*.
perhaps simply have it on by default, and force someone to go under
"Configure standard kernel features (for small systems)"
(CONFIG_EMBEDDED) to make it go away?

  seriously, how often is someone going to build a kernel for x86 and
not need MSDOS partition support?  just curious.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
