Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbZAPWHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbZAPWHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbZAPWHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:07:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbZAPWG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:06:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Date: Fri, 16 Jan 2009 23:06:11 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>
References: <20090113081316.GA2292@elf.ucw.cz> <b6a2187b0901130721y51b9618uef6efb84b7784d6@mail.gmail.com> <20090116143905.GA1933@elf.ucw.cz>
In-Reply-To: <20090116143905.GA1933@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901162306.11853.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Pavel Machek wrote:
> On Tue 2009-01-13 23:21:17, Jeff Chua wrote:
> > On Tue, Jan 13, 2009 at 10:36 PM, Pavel Machek <pavel@suse.cz> wrote:
> > > resumes fine with CONFIG_SMP unset.
> > 
> > On my X60s, I had problem with s2ram, and I switch to the following ...
> > 
> > echo mem > /sys/power/state
> > 
> > Try and see if it works for you.
> 
> I tried that; unlike s2ram, this actually produces some oopses that
> can be viewed. Unfortunately, they scroll a bit too fast.
> 
> cpu hotplug vs. cpufreq seems to be responsible in my case, looking at
> the logs from "echo 1 > online".

There are three patches from Mike Travis that can help:
http://lkml.org/lkml/2009/1/16/377

Thanks,
Rafael
