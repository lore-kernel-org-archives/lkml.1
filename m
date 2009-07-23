Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZGWSvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZGWSvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZGWSvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:51:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55185 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZGWSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:51:39 -0400
Date: Thu, 23 Jul 2009 20:51:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: xterms freezing on 2.6.31-rc2 (was Re: [regression] Re:
	2.6.31-rc2: X stop accepting keystrokes?)
Message-ID: <20090723185132.GO28158@elf.ucw.cz>
References: <20090714092459.GA2010@elf.ucw.cz> <20090715131611.GB2367@elf.ucw.cz> <20090717125946.GA2022@elf.ucw.cz> <alpine.LNX.2.00.0907171501080.11648@wotan.suse.de> <20090717130649.GA2202@elf.ucw.cz> <alpine.LNX.2.00.0907171512260.11648@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907171512260.11648@wotan.suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-17 15:13:41, Jiri Kosina wrote:
> On Fri, 17 Jul 2009, Pavel Machek wrote:
> 
> > > > ...and they seem to be slightly different crashes. Once keyboard was
> > > > dead but mouse worked, second time keyboard still worked but xterms
> > > > kept locking up. I managed to type dmesg into one of them, but that
> > > > xterm hung in middle of dump :-(.
> > > 
> > > I guess that both keyboard and mouse are PS/2 connected, right?
> > 
> > Thinkpad internal keyboard/mouse, yes.
> > 
> > > Any possibility to capture serial console output?
> > 
> > I managed to get dmesg via magic sysrq at some point. I got some
> > softlockup messages and processes seemed to hang.
> 
> Softlockup in which area?
> 
> Are you able to ssh into the machine? Where do the xterms hang? 
> (/proc/<pid>/stack)

I have not seen it for a while with new kernel, so I assume problem is gone.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
