Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZIDReE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZIDReE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZIDReD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:34:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbZIDReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:34:01 -0400
Date: Fri, 4 Sep 2009 07:33:17 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <20090904162807.1dba7a32@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0909040731080.5232@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <87pra89sgp.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.0909031353360.15956@eeepc.linux-foundation.org> <20090904162807.1dba7a32@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, Alan Cox wrote:
> 
> In which case ppp will no longer work properly in some cases (ditto
> other protocols) and things like the pppoe gateway wont work as they
> don't in 2.6.30 - you need to go back to somewhere between 2.6.28/29 to
> undo this, then apply the alternative locking patches to the
> ppp/slip/ax25/etc ldiscs

It should be fairly trivial to just add the locking to the pty write 
routines. That said, we need to fix the 2.6.31 regression, and right now 
that is the big one. If we go back to broken 2.6.30 situation, that's way 
more acceptable.

But I'm still hoping we can fix this.

			Linus
