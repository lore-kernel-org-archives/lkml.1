Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZGIWLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZGIWLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 18:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZGIWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 18:11:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58191 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755309AbZGIWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 18:11:36 -0400
Date: Thu, 9 Jul 2009 18:11:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Tony Cook <tony-cook@bigpond.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29.5: Oops when unplugging Moschip 7840/7820 USB serial
 device
In-Reply-To: <20090709214245.GA28377@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0907091810390.11378-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Greg KH wrote:

> On Thu, Jul 09, 2009 at 05:36:30PM -0400, Alan Stern wrote:
> > On Thu, 9 Jul 2009, Jeremy Fitzhardinge wrote:
> > 
> > > I unplugged a Moschip 7840/7820 USB serial adapter, and it oopsed.  I had been using it
> > > with picoterm, but it was not open at the time I unplugged it.
> > > 
> > > Thanks,
> > > 	J
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at 00000000000000b4
> > > IP: [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
> > > PGD 12e19c067 PUD 12e19d067 PMD 0 
> > > Oops: 0002 [#1] SMP 
> > > last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
> > > CPU 0 
> > > Modules linked in: mos7840 usbserial joydev aes_x86_64 aes_generic hidp fuse ipt_MASQUERADE iptable_nat nf_nat rfcomm bridge stp llc bnep sco l2cap coretemp sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath kvm_intel kvm uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec arc4 ecb snd_hwdep thinkpad_acpi iwlagn usb_storage snd_pcm hwmon btusb e1000e pcspkr iwlcore snd_timer iTCO_wdt lib80211 iTCO_vendor_support mac80211 i2c_i801 wmi snd bluetooth cfg80211 soundcore snd_page_alloc i915 drm i2c_algo_bit i2c_core video output [last unloaded: microcode]
> > > Pid: 27, comm: khubd Not tainted 2.6.29.5-191.fc11.x86_64 #1 74542GU
> > > RIP: 0010:[<ffffffff81029eb5>]  [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
> > 
> > > Call Trace:
> > >  [<ffffffff81029f7f>] default_spin_lock_flags+0x9/0xe
> > >  [<ffffffff813abf94>] _spin_lock_irqsave+0x32/0x3b
> > >  [<ffffffffa0399afa>] mos7840_shutdown+0x93/0x120 [mos7840]
> > 
> > The fix for this bug is in 2.6.30.1, but it hasn't been added to the 
> > 2.6.29.stable tree (or 2.6.27.stable).
> 
> .29 is no longer being maintained.
> 
> I didn't think the change was needed for .27, is it?

No -- I forgot for a moment where the dividing line was.

Alan Stern

