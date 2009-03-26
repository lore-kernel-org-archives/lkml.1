Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbZCZUQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbZCZUQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZCZUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:15:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41762 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZCZUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:15:54 -0400
Date: Thu, 26 Mar 2009 21:18:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Cc: linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Resume after hibernation regression in 2.6.29
Message-ID: <20090326201840.GB29836@elf.ucw.cz>
References: <200903261920.32173.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903261920.32173.tvrtko@ursulin.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
> 
> Hi guys,
> I have been running custom compiled 2.6.28.7 in OpenSUSE 11.1 and using 
> hiberation/resume daily as configured by the distro. Yesterday I upgraded to 
> 2.6.29 (make oldconfig from 2.6.28.7, attached) and after resume networking 
> (at least) does not work. Reboot at this point takes very long because of 
> timeouts on CIFS and whatelse.
> 
> Below is how /var/log/messagess looks for one cycle (hibernate-resume-reboot) 
> and I am also attaching kernel config and /var/log/pm-suspend.log.
> 
> You will probably notice evil nvidia.ko in there but don't panic, it all 
> happens without it as well. Tested from runlevel 3 and by running 
> pm-hibernate. After resume from that NIC LEDs were off. I 
> tried /etc/init.d/network restart but that hung so I ^C and tried rmmod 
> forcedeth && modprobe forcedeth && ifup eth0 and after some time network went 
> live again. Haven't had time to test further though, so this is all pretty 
> rough.

Ok, can you try to rmmod forcedeth before hibernation, then insmod it
after resume?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
