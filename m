Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYJANep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYJANep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 09:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYJANef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 09:34:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34518 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYJANed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 09:34:33 -0400
Date: Wed, 1 Oct 2008 15:36:08 +0200
From: Pavel Machek <pavel@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joe Perches <joe@perches.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       Uwe Kleine-K?nig <ukleinek@strlen.de>,
       Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] List of maintainers (draft #3)
Message-ID: <20081001133607.GA3714@elf.ucw.cz>
References: <200202071054.g17Asst06608@Port.imtp.ilyichevsk.odessa.ua> <20080922081239.GA28726@strlen.de> <20080922091256.GH1916@fluff.org.uk> <84144f020809220223jbb71877ued9d3b2569c4cd67@mail.gmail.com> <48D7CA62.1020805@zytor.com> <20080929175625.GA3676@ucw.cz> <20080930171058.9e5f48d0.rdunlap@xenotime.net> <1222819790.29215.126.camel@localhost> <20080930173512.c221ade7.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930173512.c221ade7.rdunlap@xenotime.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-09-30 17:35:12, Randy Dunlap wrote:
> On Tue, 30 Sep 2008 17:09:50 -0700 Joe Perches wrote:
> 
> > On Tue, 2008-09-30 at 17:10 -0700, Randy Dunlap wrote:
> > > On Mon, 29 Sep 2008 19:56:25 +0200 Pavel Machek wrote:
> > > > Yes please. Manually searching MAINTAINERS is  boring and hard... 'Is
> > > > it NETWORK BLOCK DEVICE' or 'NBD'? 'ALSA' or 'ADVANCED LINUX SOUND 
> > > > SYSTEM'? ... plus if you want subsystem maintainer, search tends to
> > > > give you about 179 individual driver maintainers, first.
> > > Well.... both the acronym and long name should be listed IMO.
> > > Especially the acronym/short name.
> > 
> > Human based visual searches are error prone.
> > 
> > There really does need to be some systematic and automated
> > mechanism to find the maintainers for a particular file.
> > 
> > Maintainer file patterns, either centralized in MAINTAINERS
> > or distributed in some mechanism in the file system or git
> > are useful.
> > 
> > Linus' original point about "hotness" of MAINTAINERS being
> > an issue was later refuted by Linus.
> > 
> > http://lkml.org/lkml/2008/2/13/414
> 
> I just don't think that it's a big problem like you and Pavel seem to.
> IOW I'll just disagree.

Quickly, check who's maintainer of ALSA.

...shall we add rule that subsystems will have "subsystem" in the name
so that search does not list all the drivers, first?

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3596d17..7345707 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3825,7 +3825,7 @@ L:	linux-kernel@vger.kernel.org
 W:	http://tifmxx.berlios.de/
 S:	Maintained
 
-SOUND
+SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)
 P:	Jaroslav Kysela
 M:	perex@perex.cz
 L:	alsa-devel@alsa-project.org (subscribers-only)
@@ -3855,7 +3855,7 @@ L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
 S:	Supported
 
-STABLE BRANCH:
+STABLE BRANCH
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
 P:	Chris Wright


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
