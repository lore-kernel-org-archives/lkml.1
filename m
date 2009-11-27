Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbZK0BD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbZK0BD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 20:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZK0BD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 20:03:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZK0BD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 20:03:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: Weird suspend/resume problem on HP nx6325 w/ openSUSE 11.2 w/ -rc8
Date: Fri, 27 Nov 2009 02:04:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       DRI <dri-devel@lists.sourceforge.net>
References: <200911220015.30912.rjw@sisk.pl> <21d7e9970911211955i69c12969n3085b6fc2c4a95f9@mail.gmail.com>
In-Reply-To: <21d7e9970911211955i69c12969n3085b6fc2c4a95f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911270204.15100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 November 2009, Dave Airlie wrote:
> On Sun, Nov 22, 2009 at 9:15 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > I'm not really sure where this should be reported, but here it goes.
> >
> > After installing openSUSE 11.2 on my testbed nx6325 I noticed that resume
> > (from suspend to RAM) stopped working on it.  Apparently, it hanged while
> > switching from the console back to X and the box remained completely
> > unresponsive after that (it didn't even react to the magic sysrq).  However,
> > it used to work just fine with -rc7 and openSUSE 11.1, so I figured the problem
> > was related to the new X driver, which is radeon module version 6.12.4 (xorg
> > server 1.6.5).
> >
> > So, I started to investigate and found that after a suspend from a framebuffer
> > console, the resume had always worked.  However, when I switched from X to the
> > framebuffer console, suspended, resumed and switched back to X, the box hanged
> > immediately just like during resume after a suspend from under X.  [There also
> > were some problems when switching from X to the framebuffer console and back
> > which seemd to be independent of suspend/resume (in short, the screen stays
> > black after a switch from the framebuffer console to X and you need to kill X
> > to fix this).]
> 
> You are using radeonfb on it? or vesafb?

vesafb

> first test is to try without either of those installed.

That doesn't change the behavior AFAICS.

> From memory though that machines an Xpress 200M

Yes, it has this one.

> which is the the worst graphics card for use with open drivers and has
> always caused no-end of pain.

Too bad. :-(

> Its also mostly undocumented when it comes to errata and workarounds.

Well, so I guess this is a hardware errata.

Still, it worked with the older X, so I wonder if I can make the new X work
like the old one?

Best,
Rafael
