Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYFCIac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYFCIac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYFCIaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:30:24 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:8509 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYFCIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M8Izz7GvzdB1dLO2vg6bz4itQEG9ItwLTdPzmQm5Y4g4T46pUsc6xM98p+y7iN5sI+HIcZLyaVwMgIS5YoDIpHBu6flhjWWK9ZohOb5MX7crFvtUaS1CXAgjcaVsn+eMoJD0yhBTVQo0SPBQiifmE+6yT9f4+s0QoYrjObEsYM0=
Message-ID: <dd18b0c30806030130j9273d8bq380bdea71e60250d@mail.gmail.com>
Date: Tue, 3 Jun 2008 08:30:20 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: hci_usb strikes again (was Re: BUG kmalloc-2048: Poison overwritten)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <20080603064359.GC18599@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806011613l6c8c1863rd237f7de06a6b33a@mail.gmail.com>
	 <200806020125.25918.rjw@sisk.pl> <20080602222142.GB18599@elf.ucw.cz>
	 <dd18b0c30806021612h34f776f6kb480b3aa7a1d5e41@mail.gmail.com>
	 <20080603064359.GC18599@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 6:43 AM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>> >> > cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth fan
>> >> > ipmi_watchdog ipmi_msghandler uinput wlan_tkip ieee80211_crypt_tkip
>> >> > ieee80211_crypt arpt_mangle arptable_filter arp_tables
>> >> > nf_conntrack_ipv4 nf_conntrack iptable_mangle iptable_filter ip_tables
>> >> > x_tables intelfb i2c_i810 i2c_algo_bit coretemp eeprom acpi_cpufreq
>> >> > fglrx(P) applesmc joydev uvcvideo appletouch wlan_scan_sta
>> >> > ath_rate_sample firewire_ohci firewire_core snd_hda_intel ath_pci
>> >> > snd_pcm wlan ohci1394 intel_agp evdev ath_hal(P) snd_timer ieee1394
>> >> > pata_acpi thermal ehci_hcd uhci_hcd snd_page_alloc snd_hwdep agpgart
>> >> > video button processor
>> >> > [  232.270800]
>> >> > [  232.270802] Pid: 2690, comm: btdelconn Tainted: P
>> >> > (2.6.26-rc4-00033-g5463508 #4)
>> >
>> > ...and we get oops in bluetooth.
>> >
>> > Use btusb, instead.
>> >
>> > Actually, I guess we should mark hci_usb as broken. I don't see why we
>> > should debug the same problem over and over again.
>
>> Well; "shizzle my frizzle," The funny thing is, is I have not seen
>> this after performing more suspends,
>> maybe this is a every once in a while scenario.
>
> It was "one in three" in my tests; but you need usb actively in use
> while you are suspending for this to bite.
>                                                                        Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

Aahhhh the beast has been discovered.
That's pretty cool!! I quess from my side, I'll try what you had
suggested "btusb".
("I just have to allocate enough time to do so, ("come on people", get
out of my way!!"))
I'm finding myself in one of those days where I'm away from my laptop
(contingency or not).
regards;

-- 
Justin P. Mattock
