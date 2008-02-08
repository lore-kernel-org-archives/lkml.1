Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbYBHV71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbYBHV71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYBHV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:59:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34394 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752796AbYBHV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:59:08 -0500
Date: Fri, 8 Feb 2008 22:59:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [linux-pm] Re: [rft] s2ram wakeup moves to .c, could fix few
	machines
Message-ID: <20080208215917.GA28778@elf.ucw.cz>
References: <20080208210004.GA12923@elf.ucw.cz> <47ACC942.1020308@zytor.com> <20080208213101.GE12923@elf.ucw.cz> <200802082256.09081.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802082256.09081.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-08 22:56:08, Rafael J. Wysocki wrote:
> On Friday, 8 of February 2008, Pavel Machek wrote:
> > On Fri 2008-02-08 13:27:30, H. Peter Anvin wrote:
> > > Pavel Machek wrote:
> > >>
> > >> See arch/x86/kernel/acpi/realmode/wakeup.S (the version that was sent
> > >> to the list). No problem there, but table stored at nonzero
> > >> offset. Short jump at the beggining of table would fix it (ugly).
> > >>
> > >
> > > Ugly, but it's the standard way to deal.  We have it in the bzImage format, 
> > > too.
> > 
> > I'd prefer to keep it as it is, there are no problems.
> > 
> > This way, we can put debugging instructions at the first byte of
> > wakeup code, which is somehow important.
> > 
> > Plus, with right #defines, it should be clean enough.
> 
> Well, I don't know how to evaluate #defines in *.ld files ...

See a patch in your inbox :-). Sam told me how to do it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
