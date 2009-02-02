Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZBBOld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZBBOld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZBBOlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:41:25 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:53354 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZBBOlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:41:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=my+wRXL1yldvgSg9vplxn+IAD25I8d6l0+TTpFa7TQftxcwRzWeVIKc5MPVenB+LUb
         h3srIps6W0tQmrvL+duKq5apKd6P1btFx9g4IHDlBzYc5ONgYzRRvGNdV4vY9EKubFrx
         PLxCCsJ9htXN68A5JB6z41jtEXNsm+4fWdkHE=
MIME-Version: 1.0
In-Reply-To: <c4e36d110901280305r71b3a55ah14d3ec6c1b982071@mail.gmail.com>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <20090120115500.GA4442@elte.hu>
	 <c4e36d110901220714j524343c5k2673d5626aef2460@mail.gmail.com>
	 <200901222217.09351.rjw@sisk.pl>
	 <c4e36d110901280305r71b3a55ah14d3ec6c1b982071@mail.gmail.com>
Date: Mon, 2 Feb 2009 15:41:19 +0100
Message-ID: <c4e36d110902020641j1c8be7d2o577c2fb9289815fe@mail.gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/1/22 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Thursday 22 January 2009, Zdenek Kabelac wrote:
>>> 2009/1/20 Ingo Molnar <mingo@elte.hu>:
>>> >
>>> > (Cc:-ed Johannes Berg)
> Here is just one warning I could see in my dmesg  now:
>
>
> pci 0000:15:00.0: suspend
> pci 0000:15:00.0: PCI INT A disabled
> iwl3945 0000:03:00.0: suspend
> ------------[ cut here ]------------
> WARNING: at drivers/pci/pci-driver.c:368 pci_legacy_suspend+0xdd/0xf0()
> Hardware name: 6464CTO
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 xt_state nf_conntrack ipt_RE
> JECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc sco
> l2cap bluetooth autofs4 sunrpc ipv6 binfmt_misc loop dm_mirro
> r dm_region_hash dm_log dm_mod kvm_intel kvm i915 drm i2c_algo_bit
> uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec arc4 e
> cb snd_seq_oss snd_seq_midi_event cryptomgr snd_seq aead
> snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm usbhid evdev
> crypto_blk
> cipher sdhci_pci snd_timer crypto_hash rtc_cmos sdhci mmc_core hid snd
> crypto_algapi iwl3945 mac80211 psmouse rtc_core button sou
> ndcore thinkpad_acpi rfkill backlight nvram led_class sr_mod rtc_lib
> i2c_i801 i2c_core snd_page_alloc iTCO_wdt iTCO_vendor_suppor
> t lib80211 serio_raw e1000e cfg80211 intel_agp battery ac cdrom
> uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
> Pid: 2754, comm: pm-suspend Not tainted 2.6.29-rc2 #23
> Call Trace:
>  [<ffffffff802472ef>] warn_slowpath+0xaf/0x110
>  [<ffffffff80252e60>] ? process_timeout+0x0/0x10
>  [<ffffffff80553227>] ? schedule_timeout+0x77/0xf0
>  [<ffffffff803bed65>] ? pci_bus_write_config_word+0x75/0x90
>  [<ffffffff805532be>] ? schedule_timeout_uninterruptible+0x1e/0x20
>  [<ffffffff803c2d7e>] ? pci_raw_set_power_state+0x15e/0x240
>  [<ffffffff803c2f07>] ? pci_set_power_state+0xa7/0x180
>  [<ffffffff803c5f1d>] pci_legacy_suspend+0xdd/0xf0
>  [<ffffffff803c60d5>] pci_pm_suspend+0xa5/0xb0
>  [<ffffffff804531c2>] pm_op+0x162/0x1b0
>  [<ffffffff80453acf>] device_suspend+0x47f/0x630
>  [<ffffffff802820d7>] suspend_devices_and_enter+0x47/0x1c0
>  [<ffffffff802823e6>] enter_state+0x166/0x1e0
>  [<ffffffff8028251a>] state_store+0xba/0x100
>  [<ffffffff803b0077>] kobj_attr_store+0x17/0x20
>  [<ffffffff803414cf>] sysfs_write_file+0xcf/0x140
>  [<ffffffff802e4e1b>] vfs_write+0xcb/0x190
>  [<ffffffff802e4fe5>] sys_write+0x55/0x90
>  [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 5626061031e81c26 ]---
> i801_smbus 0000:00:1f.3: suspend
> ahci 0000:00:1f.2: suspend
>


I assume it is related to this: http://lkml.org/lkml/2009/2/1/141

My machine also uses iwl3945 - will check the patch and in case it
shows different problem I'll post.

Zdenek
