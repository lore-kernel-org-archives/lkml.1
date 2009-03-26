Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbZCZVfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbZCZVfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZCZVfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:35:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbZCZVff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:35:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Resume after hibernation regression in 2.6.29
Date: Thu, 26 Mar 2009 22:35:29 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>,
       linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <200903261920.32173.tvrtko@ursulin.net> <200903262055.23749.tvrtko@ursulin.net> <20090326211406.GC29836@elf.ucw.cz>
In-Reply-To: <20090326211406.GC29836@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903262235.29576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009, Pavel Machek wrote:
> On Thu 2009-03-26 20:55:23, Tvrtko A. Ursulin wrote:
> > On Thursday 26 March 2009 20:18:40 Pavel Machek wrote:
> > > On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
> > > > Hi guys,
> > > > I have been running custom compiled 2.6.28.7 in OpenSUSE 11.1 and using
> > > > hiberation/resume daily as configured by the distro. Yesterday I upgraded
> > > > to 2.6.29 (make oldconfig from 2.6.28.7, attached) and after resume
> > > > networking (at least) does not work. Reboot at this point takes very long
> > > > because of timeouts on CIFS and whatelse.
> > > >
> > > > Below is how /var/log/messagess looks for one cycle
> > > > (hibernate-resume-reboot) and I am also attaching kernel config and
> > > > /var/log/pm-suspend.log.
> > > >
> > > > You will probably notice evil nvidia.ko in there but don't panic, it all
> > > > happens without it as well. Tested from runlevel 3 and by running
> > > > pm-hibernate. After resume from that NIC LEDs were off. I
> > > > tried /etc/init.d/network restart but that hung so I ^C and tried rmmod
> > > > forcedeth && modprobe forcedeth && ifup eth0 and after some time network
> > > > went live again. Haven't had time to test further though, so this is all
> > > > pretty rough.
> > >
> > > Ok, can you try to rmmod forcedeth before hibernation, then insmod it
> > > after resume?
> > 
> > Sure, after insmod and /etc/init.d/network start following resume network was 
> > fine. Guess I could kludge that sequence into pm scripts somehow but would 
> > rather avoid that since it slows down the cycle and would make scripts 
> > non-stock.
> 
> Ok, I guess you need to talk to forcedeth maintainers then... sounds
> like a forcedeth problem to me.

I have a box with forcedeth somewhere here, I should be able to check that
in the next few days.

Thanks,
Rafael
