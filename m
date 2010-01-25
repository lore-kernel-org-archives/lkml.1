Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219Ab0AYSY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0AYSY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055Ab0AYSY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:24:28 -0500
Received: from www.tglx.de ([62.245.132.106]:53604 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab0AYSY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:24:27 -0500
Date: Mon, 25 Jan 2010 19:22:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [00/29] 2.6.32.6 stable review
In-Reply-To: <20100125171631.GB17421@kroah.com>
Message-ID: <alpine.LFD.2.00.1001251920110.5926@localhost.localdomain>
References: <20100123001145.GA7391@kroah.com> <20100123232152.4b88d1e3.akpm@linux-foundation.org> <alpine.LFD.2.00.1001241727560.2906@localhost.localdomain> <4B5D5903.4000209@pardus.org.tr> <20100125171631.GB17421@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-249730774-1264443751=:5926"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-249730774-1264443751=:5926
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jan 2010, Greg KH wrote:

> On Mon, Jan 25, 2010 at 10:40:35AM +0200, Ozan Çağlayan wrote:
> > Thomas Gleixner wrote On 24-01-2010 18:29:
> > > On Sat, 23 Jan 2010, Andrew Morton wrote:
> > > 
> > >> On Fri, 22 Jan 2010 16:11:45 -0800 Greg KH <gregkh@suse.de> wrote:
> > >>
> > >>> This is the start of the stable review cycle for the 2.6.32.6 release.
> > >>> There are 29 patches in this series, all will be posted as a response to
> > >>> this one.  If anyone has any issues with these being applied, please let
> > >>> us know.  If anyone is a maintainer of the proper subsystem, and wants
> > >>> to add a Signed-off-by: line to the patch, please respond with it.
> > >>>
> > >>> Responses should be made by Monday, January 24, 00:00:00 UTC.
> > >>> Anything received after that time might be too late.
> > >> 2.6.32.6 will still contain the regression described in (for example)
> > >>
> > >> http://bugzilla.kernel.org/show_bug.cgi?id=15117 
> > >> http://bugzilla.kernel.org/show_bug.cgi?id=15005
> > >>
> > >> It's fixed with the below revert which has been in -mm (and only in
> > >> -mm) for ten days.
> > >>
> > >> I don't what's going on - perhaps we're waiting for Thomas, and he's
> > >> otherwise engaged.  There's a fix in the lkml thread "Re: [RFC PATCH
> > >> 0/4] clockevents: fix clockevent_devices list corruption after cpu
> > >> hotplug" to which Thomas replied
> > >>
> > >>     I just applied your patch, but kept the cpuweight check.  This
> > >>     is the least intrusive solution for now.  The logic needs an
> > >>     overhaul, but thats neither rc4 nor stable material"
> > > 
> > > Just sent the pull request for it. Sorry for the delay. The patch
> > > needs to go into 32.6 as well.
> > 
> > tick-internal.h should be included for this to fix build failure. Already included
> > in 2.6.33 with 8e1a928a2ed7e8.
> 
> Huh?  That says:
> 	clockevents: Add missing include to pacify sparse
> 
> and does not sound like a problem that needs to be fixed for "real"
> users, right?
> 
> Or does .32.6 have a build problem somewhere?

If you pick ea9d8e3f45404d411c00ae67b45cc35c58265bb7 then you need
that include.

Thanks,

	tglx
--8323328-249730774-1264443751=:5926--
