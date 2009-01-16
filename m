Return-Path: <linux-kernel-owner+w=401wt.eu-S935488AbZAPOhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488AbZAPOhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZAPOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:37:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56690 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZAPOhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:37:03 -0500
Date: Fri, 16 Jan 2009 15:39:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Message-ID: <20090116143905.GA1933@elf.ucw.cz>
References: <20090113081316.GA2292@elf.ucw.cz> <20090113143646.GB1983@elf.ucw.cz> <b6a2187b0901130721y51b9618uef6efb84b7784d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0901130721y51b9618uef6efb84b7784d6@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-13 23:21:17, Jeff Chua wrote:
> On Tue, Jan 13, 2009 at 10:36 PM, Pavel Machek <pavel@suse.cz> wrote:
> > resumes fine with CONFIG_SMP unset.
> 
> On my X60s, I had problem with s2ram, and I switch to the following ...
> 
> echo mem > /sys/power/state
> 
> Try and see if it works for you.

I tried that; unlike s2ram, this actually produces some oopses that
can be viewed. Unfortunately, they scroll a bit too fast.

cpu hotplug vs. cpufreq seems to be responsible in my case, looking at
the logs from "echo 1 > online".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
