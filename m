Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbZAQAOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbZAQAOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762717AbZAQAN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:13:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762671AbZAQAN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:13:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Travis <travis@sgi.com>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Date: Sat, 17 Jan 2009 01:13:09 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Pavel Machek <pavel@suse.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20090113081316.GA2292@elf.ucw.cz> <200901162306.11853.rjw@sisk.pl> <49711EBC.5050101@sgi.com>
In-Reply-To: <49711EBC.5050101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901170113.09724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 January 2009, Mike Travis wrote:
> Rafael J. Wysocki wrote:
> > On Friday 16 January 2009, Pavel Machek wrote:
> >> On Tue 2009-01-13 23:21:17, Jeff Chua wrote:
> >>> On Tue, Jan 13, 2009 at 10:36 PM, Pavel Machek <pavel@suse.cz> wrote:
> >>>> resumes fine with CONFIG_SMP unset.
> >>> On my X60s, I had problem with s2ram, and I switch to the following ...
> >>>
> >>> echo mem > /sys/power/state
> >>>
> >>> Try and see if it works for you.
> >> I tried that; unlike s2ram, this actually produces some oopses that
> >> can be viewed. Unfortunately, they scroll a bit too fast.
> >>
> >> cpu hotplug vs. cpufreq seems to be responsible in my case, looking at
> >> the logs from "echo 1 > online".
> > 
> > There are three patches from Mike Travis that can help:
> > http://lkml.org/lkml/2009/1/16/377
> > 
> > Thanks,
> > Rafael
> 
> Note that these don't really fix anything, just replaces the current
> method of using set_cpus_allowed with the work_on_cpu call.  If
> the laptop worked before the [bad] patch, then it should work again
> now with this one.

Thanks for the clarification, I misread the changelogs.

OK, so we still have a cpufreq vs CPU hotplug problem, it seems.  I can't
reproduce it myself, though.

Thanks,
Rafael
