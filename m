Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZGUAmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZGUAmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 20:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZGUAmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 20:42:37 -0400
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:46180 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbZGUAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 20:42:36 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30.2: does not boot
Date: Tue, 21 Jul 2009 02:42:33 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30.2; KDE/4.2.4; i686; ; )
Cc: Kiko Piris <kernel@pirispons.net>, Damien Wyart <damien.wyart@free.fr>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20090720040813.GC11940@kroah.com> <20090720211908.GA31814@superlopez.pirispons.net> <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907201458000.19335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907210242.33602.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Linus Torvalds wrote:
> 
> On Mon, 20 Jul 2009, Kiko Piris wrote:
> > > Just to clarify:
> > > 
> > >  - you literally have a _working_ 2.6.30.1 that you compiled yourself a 
> > >    few days ago.
> > 
> > That’s correct.
> > 
> > >  - But when you try to compile that same kernel _now_, it fails with an 
> > >    immediate reboot? And not just 2.6.30.2, but 2.6.30.1 does that too?
> > 
> > Also correct.
> > 
> > > That certainly implies something else than just the -fwrapv vs 
> > > -fno-strict-overflow thing.
> > 
> > Yes, as Marcel Beister pointed, it resulted some binutils bug.
> > Downgrading the package produced a perfectly bootable 2.6.30.2.
> 
> Ok, so it's been narrowed down to binutils. Good.
> 
> > > But we may be looking at two different issues, so maybe your "unable to 
> > > compile a working kernel" issue is different from the other reports.
> > 
> > Totally unrelated to other reports, and not a kernel bug, in fact.
> 
> Well, it's still not entirely clear that it's unrelated.
> 
> It seems that all the people involved are running Debian/sid, and I don't 
> think we have any firm confirmation yet that it's the compiler flag for 
> anybody. It was certainly the primary suspect, but maybe that was always 
> just a red herring guess.
> 
> Wolfgang hasn't actually tried to compile without the -fno-strict-overflow 
> flag yet, and maybe his hang is the same binutils bug.

Yes, it is.

I built with -fwrapv instead of  -fno-strict-overflow and without either, both 
fail to boot.

Downgrading binutils to those of debian/testing and the unmodified 2.6.30.2 
works.

So this seems to be indeed a problem with binutils in debian/sids.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196-276
Fax: +49 89 38196-144
wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
