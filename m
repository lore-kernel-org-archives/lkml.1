Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXLIVVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXLIVVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXLIVVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:21:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58892 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751454AbXLIVVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:21:01 -0500
Date: Sun, 9 Dec 2007 22:21:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
Message-ID: <20071209212132.GB24284@elf.ucw.cz>
References: <200712031419.41596.toralf.foerster@gmx.de> <200712032254.23656.rjw@sisk.pl> <20071209174108.GH4381@ucw.cz> <200712092231.41064.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712092231.41064.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-09 22:31:40, Rafael J. Wysocki wrote:
> On Sunday, 9 of December 2007, Pavel Machek wrote:
> > On Mon 2007-12-03 22:54:23, Rafael J. Wysocki wrote:
> > > On Monday, 3 of December 2007, Toralf Förster wrote:
> > > > Hhm,
> > > > 
> > > > in general it seems to be a regression of kernel 2.6.23 with suspend/hibernate
> > > > if a user mode linux image is runnning.
> > > > 
> > > > With previous kernel versions (tested gentoo-sources-2.6.22-r9 and 
> > > > gentoo-sources-2.6.21-r4) I've no problem to either suspend or to hibernate the
> > > > ThinkPad T41.
> > > > 
> > > > However with gentoo-sources-2.6.23-r3 the system didn't neither
> > > > suspend nor hibernate. The good news is that the system doesn't hang :-)
> > >  
> > > Please file a bug report at
> > > http://bugzilla.kernel.org/enter_bug.cgi?product=Power%20Management
> > > against Hibernation/Suspend and add my address to the report's CC list.
> > 
> > I smell refrigerator problem; can you suspend if you SIGSTOP your uml,
> > first?
> 
> That might be, but the issue is apparently fixed in 2.6.24-rc and I'm
> struggling to figure out how the !@#$%^ (please see
> http://bugzilla.kernel.org/show_bug.cgi?id=9501).

No idea... I'm glad its fixed :-). Maybe someone fixed uninterruptible
sleep somewhere in ptrace...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
