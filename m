Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZG0Wpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZG0Wpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZG0Wpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:45:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37100 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbZG0Wpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:45:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [Bug #13839] xc5000 no longer works with Myth-0.21-fixes branch
Date: Tue, 28 Jul 2009 00:46:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Devin Heitmueller <dheitmueller@kernellabs.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.Y0B.HHObKB@chimera> <4A6D0D5B.2000607@rtr.ca>
In-Reply-To: <4A6D0D5B.2000607@rtr.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280046.13881.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Mark Lord wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13839
> > Subject		: xc5000 no longer works with Myth-0.21-fixes branch
> > Submitter	: Mark Lord <lkml@rtr.ca>
> > Date		: 2009-07-19 15:15 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124814394016848&w=4
> > Handled-By	: Devin Heitmueller <dheitmueller@kernellabs.com>
> ..
> 
> There is definitely a regression, in that it doesn't work without
> config changes to Myth.  This is due to the new way that firmware uploads
> are implemented in xc5000:  slower, and more often than before.
> 
> But the MythTV workaround required is simple:
> 
> > 3. In mythtv-setup -> CaptureCards -> DVB:1 -> RecordingOptions
> > there is a tickbox for "Open DVB Card on Demand".  It was ticked,
> > so I un-ticked that box.  Everything now works!
> > 
> > When that tickbox was selected, the xc5000 took five (5) seconds to "open",
> > as it did the firmware upload every time.  This appeared to exceed some
> > timeout inside myth.
> > 
> > With the tickbox NOT ticked, myth just opens the tuner once at startup,
> > and keeps it open, so no more delay when it wants to use it. 
> 
> 
> Dunno what to say about this one.

Well, let's close it as 'documented'.

Thanks,
Rafael
