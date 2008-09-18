Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYIRLWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYIRLWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYIRLWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:22:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34008 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYIRLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:22:22 -0400
Date: Thu, 18 Sep 2008 13:06:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI "Soft-off" power button only rebooting system, not
	powering off
Message-ID: <20080918110635.GF27832@elf.ucw.cz>
References: <76366b180809162150o51701a1fk209af4e84ffc5674@mail.gmail.com> <20080917101809.GA4771@elf.ucw.cz> <76366b180809170533t6962f3d0qf67278b2e9ff6bd0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180809170533t6962f3d0qf67278b2e9ff6bd0@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-09-17 08:33:50, Andrew Paprocki wrote:
> On Wed, Sep 17, 2008 at 6:18 AM, Pavel Machek <pavel@suse.cz> wrote:
> > On Wed 2008-09-17 00:50:03, Andrew Paprocki wrote:
> >> I have an AMD / Award BIOS based system which does not properly shut
> >> off when I hold down the power button for 4 seconds. The BIOS is
> >> configured to have "Soft-off" set to "Delay for 4 seconds" which is
> >> supposed to power the machine off if the button is held that long.
> >>
> >> I first thought this could be a BIOS bug, but this *only* appears to
> >> happen while Linux is running. If the computer is running WinXP, it
> >
> > Well, so the BIOS is broken. 4second hold should power down the
> > machine regardless of the operating system.
> 
> Yes, I agree.. I just find it strange that it works on the BIOS screen
> as well as in GRUB, but as soon as Linux boots, it no longer works.
> Since it works under WinXP, there must be some way to get it to work
> properly from the OS side even it if means working around the bug
> somehow.

Try noapic/nolapic/nosmp etc... and ask your vendor to fix the bios ;-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
