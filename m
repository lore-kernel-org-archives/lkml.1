Return-Path: <linux-kernel-owner+w=401wt.eu-S1946128AbXBIXzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946128AbXBIXzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946516AbXBIXzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:55:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2814 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946128AbXBIXzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:55:32 -0500
Date: Fri, 9 Feb 2007 22:24:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Message-ID: <20070209222445.GB3949@ucw.cz>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070202161611.cf8b4328.akpm@linux-foundation.org> <20070203003536.GA619@khazad-dum.debian.net> <1170710913.6105.39.camel@nigel.suspend2.net> <20070206143231.GD18392@khazad-dum.debian.net> <1170797924.14398.19.camel@nigel.suspend2.net> <20070207112539.GD8148@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207112539.GD8148@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-02-07 09:25:39, Henrique de Moraes Holschuh wrote:
> On Wed, 07 Feb 2007, Nigel Cunningham wrote:
> > Ok, as far as usage scenario goes, that's fair enough. But as to the
> > solution, I wonder though whether it's making life more complicated than
> > it needs to be. After all, we should also be able to cope okay with
> > having the power suddenly go out. If we can cope with that, cleaning
> > filesystems prior to suspending should be a non-issue.
> 
> We don't cope okay with the power going out, at all.  And as an user case, a
> need for fsck if you do something that is a reasonable use case (unplugging
> devices while suspended) is not okay, either.

It would be nice to umount devices over suspend, but I do not think
solution is as easy as patch that started this thread. For now it is
'dont do that' and fsck is nice reminder that you done something
wrong.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
