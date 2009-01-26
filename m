Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZAZQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZAZQl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZAZQlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:41:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZAZQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:41:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Date: Mon, 26 Jan 2009 17:40:38 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Mike Travis <travis@sgi.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20090113081316.GA2292@elf.ucw.cz> <200901170113.09724.rjw@sisk.pl> <20090126154444.GA23780@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090126154444.GA23780@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261740.39003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2009, Pavel Machek wrote:
> Hi!
> 
> > > > There are three patches from Mike Travis that can help:
> > > > http://lkml.org/lkml/2009/1/16/377
> > > > 
> > > > Thanks,
> > > > Rafael
> > > 
> > > Note that these don't really fix anything, just replaces the current
> > > method of using set_cpus_allowed with the work_on_cpu call.  If
> > > the laptop worked before the [bad] patch, then it should work again
> > > now with this one.
> > 
> > Thanks for the clarification, I misread the changelogs.
> > 
> > OK, so we still have a cpufreq vs CPU hotplug problem, it seems.  I can't
> > reproduce it myself, though.
> 
> I kind of lost track here. Is everything fixed, or will there still be
> problems in -rc3?

That depends on which patches get merged before -rc3.  There are quite a few
of them. :-(

Thanks,
Rafael
