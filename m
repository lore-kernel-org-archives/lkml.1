Return-Path: <linux-kernel-owner+w=401wt.eu-S1751302AbXBMMMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbXBMMMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXBMMMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:12:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60769 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302AbXBMMMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:12:35 -0500
Date: Tue, 13 Feb 2007 13:12:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070213121213.GI18101@elf.ucw.cz>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org> <20070203003536.GA619@khazad-dum.debian.net> <1170710913.6105.39.camel@nigel.suspend2.net> <20070206143231.GD18392@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206143231.GD18392@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Why do you think remounting filesystems is necessary? Are you getting
> > problems with some particular filesystem?
> 
> No.  But anything in a removable device neets to be either remounted
> read-only or unmounted if that is at all possible, because the user could
> unplug it.  It is of course, sync'd anyway, so if the remount/umount fails,
> no corruption should happen...  but the fs will be dirty, etc.
> 
> It can get very ugly when you factor in docks and removable bays. It's not
> just USB/firewire mass-storage devices and memory cards.  And there is the
> patological cases where the user suspends with the device in one port, and
> resumes with the device in another port.
> 
> I feel userspace *can* do all that needs to be done, but we are (currently)
> very bad at it.

Fix it in userspace, then. fsck when you unplug disk while suspended
should serve as a reminder to fix that userspace :-).

(And yes, you may need some kernel support to do it nicely; hopefully
same kernel support that will solve users unplugging disks without
umount.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
