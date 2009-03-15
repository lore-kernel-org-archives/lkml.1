Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZCOKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZCOKmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZCOKl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:41:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbZCOKlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:41:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
Date: Sun, 15 Mar 2009 11:41:58 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com> <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
In-Reply-To: <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151141.59098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 March 2009, Jeff Chua wrote:
> On Sun, Mar 15, 2009 at 10:58 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Sun, Mar 15, 2009 at 3:01 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> >> Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> >> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> >> Date            : 2009-01-05 4:13 (69 days old)
> >> References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4
> >
> > Still not working in linux-2.6.29-rc8. Broken after the commit below.
> > There were many changes to wireless after this commit, and simply
> > reverting this commit will break compiling.
> >
> > Jeff.
> >
> >
> >
> > commit 41bb73eeac5ff5fb217257ba33b654747b3abf11
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Wed Oct 29 01:09:37 2008 +0100
> >
> >    mac80211: remove SSID driver code
> >
> 
> The commit below is causing problem with associating with the hidden AP as well.
> 
> Thanks,
> Jeff.
> 
> 
> 71c11fb57b924c160297ccd9e1761db598d00ac2 is first bad commit
> commit 71c11fb57b924c160297ccd9e1761db598d00ac2
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue Oct 28 18:29:48 2008 +0100
> 
>     b43/legacy: remove SSID code
> 
>     The SSID programmed into the device is used by the ucode only
>     to reply to probe requests, a functionality we disable anyway
>     because it doesn't fit with the mac80211/hostapd programming
>     model. Therefore, it isn't useful to program the SSID into
>     device.
> 
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks for the update.

Rafael
