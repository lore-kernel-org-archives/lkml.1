Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbXGKReo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbXGKReo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXGKRei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:34:38 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1528 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbXGKReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:34:37 -0400
Date: Wed, 11 Jul 2007 19:34:41 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Rodolfo Giometti <giometti@enneenne.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
In-Reply-To: <20070711152455.GK31193@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0707111853170.1817@scrub.home>
References: <1183031060.1170.145.camel@pmac.infradead.org>
 <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca>
 <200707110318.49244.zippel@linux-m68k.org> <20070711152455.GK31193@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 11 Jul 2007, Lennart Sorensen wrote:

> On Wed, Jul 11, 2007 at 03:18:46AM +0200, Roman Zippel wrote:
> > This is really not an API that needs to deal with such large time range.
> 
> No one will want to use PPS API to keep accurate time past 2030?  Why
> not?  Or should we be forced to invent a new PPS API before then to fix
> this one?

That's not necessary.

> Actually, come to think of it, is this passing a current time, or it it
> passing an interval since last PPS?  If it is an interval, then yes
> never mind, we don't need that many seconds (usually 1 or 2 at most).
> For some reason I thought this was for passing the current time of a
> stamp.

It's an absolute time stamp, but users of this interface are more 
interested in the time difference between events and how they change over 
time. E.g. NTP time stamps are 64bit fixed point values with a 32bit 
integral part.
This is not an interface to read the current system time, so 32bit will 
continue to work.

bye, Roman
