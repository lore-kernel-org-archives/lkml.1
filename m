Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYFCGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYFCGnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYFCGnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:43:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38375 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYFCGnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:43:09 -0400
Date: Tue, 3 Jun 2008 08:43:59 +0200
From: Pavel Machek <pavel@suse.cz>
To: Justin Mattock <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: hci_usb strikes again (was Re: BUG kmalloc-2048: Poison
	overwritten)
Message-ID: <20080603064359.GC18599@elf.ucw.cz>
References: <dd18b0c30806011613l6c8c1863rd237f7de06a6b33a@mail.gmail.com> <200806020125.25918.rjw@sisk.pl> <20080602222142.GB18599@elf.ucw.cz> <dd18b0c30806021612h34f776f6kb480b3aa7a1d5e41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30806021612h34f776f6kb480b3aa7a1d5e41@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >> > cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth fan
> >> > ipmi_watchdog ipmi_msghandler uinput wlan_tkip ieee80211_crypt_tkip
> >> > ieee80211_crypt arpt_mangle arptable_filter arp_tables
> >> > nf_conntrack_ipv4 nf_conntrack iptable_mangle iptable_filter ip_tables
> >> > x_tables intelfb i2c_i810 i2c_algo_bit coretemp eeprom acpi_cpufreq
> >> > fglrx(P) applesmc joydev uvcvideo appletouch wlan_scan_sta
> >> > ath_rate_sample firewire_ohci firewire_core snd_hda_intel ath_pci
> >> > snd_pcm wlan ohci1394 intel_agp evdev ath_hal(P) snd_timer ieee1394
> >> > pata_acpi thermal ehci_hcd uhci_hcd snd_page_alloc snd_hwdep agpgart
> >> > video button processor
> >> > [  232.270800]
> >> > [  232.270802] Pid: 2690, comm: btdelconn Tainted: P
> >> > (2.6.26-rc4-00033-g5463508 #4)
> >
> > ...and we get oops in bluetooth.
> >
> > Use btusb, instead.
> >
> > Actually, I guess we should mark hci_usb as broken. I don't see why we
> > should debug the same problem over and over again.

> Well; "shizzle my frizzle," The funny thing is, is I have not seen
> this after performing more suspends,
> maybe this is a every once in a while scenario.

It was "one in three" in my tests; but you need usb actively in use
while you are suspending for this to bite.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
