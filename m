Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbYALHPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbYALHPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 02:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbYALHPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 02:15:45 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:60577 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758371AbYALHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 02:15:44 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2008 02:15:44 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HALb0h0d5LCjq/2dsb2JhbACBVqgm
X-IronPort-AV: E=Sophos;i="4.24,275,1196602200"; 
   d="scan'208";a="21342039"
To: Bodo Eggert <7eggert@gmx.de>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Bodo Eggert <7eggert@gmx.de>, Matthias Schniedermeyer <ms@citd.de>,
       Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
From: TimC <tconnors@astro.swin.edu.au>
Subject: Re: The ext3 way of journalling
Mail-Copies-To: tconnors@astro.swin.edu.au
In-reply-to: <alpine.LSU.0.999.0801120236500.9944@be1.lrz>
References: <9JpbI-5yi-9@gated-at.bofh.it> <9Jqri-7ym-17@gated-at.bofh.it> <9JqUn-8bF-15@gated-at.bofh.it> <9JvKj-85h-41@gated-at.bofh.it> <E1JDMeb-0003qH-Mv@be1.7eggert.dyndns.org> <20080111183927.GM2310@csclub.uwaterloo.ca> <alpine.LSU.0.999.0801120236500.9944@be1.lrz>
X-test-to: Bodo Eggert <7eggert@gmx.de>
X-cc-to: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Bodo Eggert <7eggert@gmx.de>, Matthias Schniedermeyer <ms@citd.de>, Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
X-reply-to-bofh-messageid: <9KDFA-7Xq-1@gated-at.bofh.it>
X-Editor: xemacsclientserver
X-EndlessSeptember: Sat Sep 5247 18:08:36 EST 1993
X-yes-we-have-no-x-yes-archive-today: NO
X-Face: "/6m>=uJ8[yh+S{nuW'%UG"H-:QZ$'XRk^sOJ/XE{d/7^|mGK<-"*e>]JDh/b[aqj)MSsV`X1*pA~Uk8C:el[*2TT]O/eVz!(BQ8fp9aZ&RM=Ym&8@.dGBW}KDT]MtT"<e(`rn*-w$3tF&:%]KHf"{~`X*i]=gqAi,ScRRkbv&U;7Aw4WvC
X-Face-Author: David Bonde mailto:i97_bed@i.kth.se.REMOVE.THIS.TO.REPLY -- If you want to use it please also use this Authorline.
Message-ID: <slrn-0.9.7.4-27208-4606-200801121808-tc@hexane.ssi.swin.edu.au>
Date: Sat, 12 Jan 2008 18:10:18 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> said on Sat, 12 Jan 2008 02:41:17 +0100 (CET):
> On Fri, 11 Jan 2008, Lennart Sorensen wrote:
> > On Fri, Jan 11, 2008 at 05:22:45PM +0100, Bodo Eggert wrote:
> 
> > > What can happen if someone does tune2fs -Lroot /dev/usbstick
> > > and puts that stick into this system?
> > 
> > Don't know.  I use UUIDs rather than LABELs.  Having duplicated labels
> > just means being careless.  Having duplicate UUIDs should require being
> > malicous.
> 
> That's exactly what you have to assume for your users. Otherwise, you could 
> remove any security feature from the system.

If they've got physical access to your machine, you've already lost.

-- 
TimC
A bug in the code is worth two in the documentation. --unknown
