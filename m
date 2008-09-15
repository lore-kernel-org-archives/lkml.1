Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYIOAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYIOAIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 20:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYIOAIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 20:08:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYIOAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 20:08:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #11398] hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Date: Mon, 15 Sep 2008 02:13:31 +0200
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <200809130937.52685.elendil@planet.nl> <s5habecm03s.wl%tiwai@suse.de>
In-Reply-To: <s5habecm03s.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150213.32780.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 of September 2008, Takashi Iwai wrote:
> At Sat, 13 Sep 2008 09:37:51 +0200,
> Frans Pop wrote:
> > 
> > On Friday 12 September 2008, Rafael J. Wysocki wrote:
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.26.  Please verify if it still should be listed and let me
> > > know (either way).
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11398
> > > Subject	: hda_intel: IRQ timing workaround is activated for card #0.
> > > 		  Suggest a bigger bdl_pos_adj.
> > 
> > Still there.
> 
> Yeah, the driver wasn't changed about this.
> 
> Basically it's a warning message that CPU usage got higher due to
> somehow wrongly behaving hardware.  The driver behavior itself didn't
> do anything wrong.  That is, if the driver didn't show it, you
> wouldn't have noticed any change (or noticed improvements in some apps
> :)
> 
> Of course, it would be ideal if we can add a perfect workaround for
> it, but right now, I have no idea what to do better.  So, I don't
> think it's worth to keeping this open as a regression.

I've closed the bug.

Thanks,
Rafael
