Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYBAL1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYBAL1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYBAL1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:27:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58351 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYBAL1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:27:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: swsusp on an AMD x2-64, 2.6.24: regression?
Date: Fri, 1 Feb 2008 12:25:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Linux-kernel <linux-kernel@vger.kernel.org>
References: <47A24072.4090001@msgid.tls.msk.ru> <20080131231219.GA14355@elf.ucw.cz> <47A2F168.8070407@msgid.tls.msk.ru>
In-Reply-To: <47A2F168.8070407@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011225.11571.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Michael Tokarev wrote:
> Pavel Machek wrote:
> > On Fri 2008-02-01 00:41:06, Michael Tokarev wrote:
> []
> >> With 2.6.24, it tries to suspend, saves pages to disk,
> >> when prints this:
> >>
> >> ..Saving pages... done.
> >> Sl
> 
> It's actually "S|", not "Sl".
> 
> >> Suspending console(s)
> >> _
> >>
> >> At this point, nothing more happens.  It does not
> >> react to keyboard or to any other external events,
> 
> ..because the keyboard is USB-connected, and it shuts
> down all USB devices.  I'll try with PS/2 keyboard
> (when I'll find one I had somewhere... ;)
> 
> []
> > no_console_suspend (sp?), nohz=off, highres=off, and try with minimum
> > config.
> 
> no_console_suspend it is.  Tried that, the "S|" thing is still
> here, but instead of "Suspending console(s)" it now shows
> progress of suspending other devices.  The end result is
> the same - finally it stops and sits here ad infinitum.

I guess it's a special variation of
http://bugzilla.kernel.org/show_bug.cgi?id=9528

Please try to hibernate in the shutdown mode (ie. echo
"shutdown" into /sys/power/disk before hibernation).

Thanks,
Rafael
