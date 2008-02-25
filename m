Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbYBYU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbYBYU6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYBYU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:58:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbYBYU6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:58:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Date: Mon, 25 Feb 2008 21:57:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Jeff Garzik <jeff@garzik.org>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com> <20080225114611.d91791f6.akpm@linux-foundation.org> <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com>
In-Reply-To: <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252157.10412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Michael S. Tsirkin wrote:
> On Mon, Feb 25, 2008 at 9:46 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:
> >
> >  > On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
> >  > such as Fn-F4 and lid open/close, prints them in /var/log/acpid
> >  > and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).
> >
> >  You mean suspend-to-ram works correctly on your t61p?
> >
> >  Mine suspends, then five seconds later magically resumes itself and the
> >  screen is all black.
> 
> Sorry, have not noticed what you were asking about.
> Yes, rc2 seems to suspend/resume fine.
> 
> And after reverting
> 
>      revert commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.

commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
Author: Pavel Machek <pavel@ucw.cz>
Date:   Thu Feb 21 13:56:55 2008 +0100

    power_state: get rid of write-only variable in SATA

>      revert commit 208c70a45624400fafd7511b96bc426bf01f8f5e.

commit 208c70a45624400fafd7511b96bc426bf01f8f5e
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Thu Feb 14 15:58:47 2008 -0500

    ACPI: EC: Use proper handle for boot EC

> r3 does, too.

Please, _please_ always add commit subjects to your reports.  Also, please
include the names of the authors of the commits that turn out to break things
and send CCs to them.

It won't hurt to send CCs to the people who signed those commits off, too.

Thanks,
Rafael
