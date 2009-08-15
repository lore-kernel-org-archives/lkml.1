Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZHOQge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZHOQge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZHOQgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:36:33 -0400
Received: from web33501.mail.mud.yahoo.com ([68.142.206.150]:41191 "HELO
	web33501.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755169AbZHOQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:36:32 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Aug 2009 12:36:32 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=tTx023LtAmxf5bRfx/De0MulKmurCDmIUOs1w/ClOcEAMe5MRsvI+f9UYx+AJrtbgZ27GtXrPAWuYWtYQmxlKPNMx+U9ibLaVR9oGz1pbydOg5d/DmjOoCu5sW9k6nvHMnHvZLQu+CZ5SVj0HD60gBySBa5g8gm8alIV0i4sjo4=;
Message-ID: <10435.90035.qm@web33501.mail.mud.yahoo.com>
X-YMail-OSG: 3YlYlRoVM1mV2atwrGtuQTB20gW5_N1V38a9MxxaXph9D_WSU5W7q27XXJlPPkLum3ruguBkbmMjWnGtFB.4zt32JSKM7tiIV4MOjN54peGnEgh3CbADa36dbKFH57nzOpS7YnL2ePMJX7SxoYbg5F_bFP3eaHkRNa1g7_EqAK_moWEDl7rWxACLRWbY.umJ4x6R3K_rcGd_5BN2A8RYd6IOKmsHI0KbRGXXYBEW9lWMxQ7IgfE0fScVSh_l9OnwYY1Y5hscuDYEXJYy6yxll45Vi0mSLnnoIGtChzeZGnJ5jZBp
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Sat, 15 Aug 2009 09:29:51 -0700 (PDT)
From: Nick Levinson <nick_levinson@yahoo.com>
Subject: a kernel failure message
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following appeared earlier today, after logging into a nonroot account (the only login today) and opening the Firefox 3.0.4 browser; kernel failures were reported on several recent days but I did not report them to you, not knowing the email address at the time (I prefer email over machine-to-machine contact); they did not occur after the clean install of Fedora 10 Linux until recently; and I have not changed the hardware or installed new software in recent days:

* * * * *
Kernel failure message 1:
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:219 dev_watchdog+0xda/0x12d()
NETDEV WATCHDOG: eth1 (orinoco_cs): transmit timed out
Modules linked in: vfat fat usb_storage fuse ipt_MASQUERADE iptable_nat nf_nat sco bridge stp bnep l2cap bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath uinput orinoco_cs orinoco hermes ppdev dcdbas snd_intel8x0 snd_intel8x0m snd_ac97_codec snd_seq_dummy ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm irda snd_timer crc_ccitt floppy snd soundcore pcspkr joydev snd_page_alloc iTCO_wdt firewire_ohci iTCO_vendor_support firewire_core 3c59x crc_itu_t yenta_socket intel_rng rsrc_nonstatic mii video output parport_pc parport ata_generic pata_acpi sha256_generic cbc aes_i586 aes_generic dm_crypt crypto_blkcipher [last unloaded: microcode]
Pid: 3048, comm: gnome-screensav Not tainted 2.6.27.5-117.fc10.i686 #1
 [<c042bb3a>] warn_slowpath+0x4b/0x6c
 [<c043a716>] ? __queue_work+0x26/0x2b
 [<c043a784>] ? queue_work_on+0x3b/0x46
 [<c048a971>] ? virt_to_head_page+0x22/0x2e
 [<c050c0d4>] ? queue_flag_clear+0x18/0x54
 [<c050c17b>] ? __freed_request+0x6b/0x72
 [<c0420940>] ? __enqueue_entity+0xe3/0xeb
 [<c06a77cc>] ? _spin_lock_irqsave+0x29/0x30
 [<c051bf6e>] ? strlcpy+0x17/0x49
 [<c063e554>] dev_watchdog+0xda/0x12d
 [<c043495a>] ? mod_timer+0x30/0x34
 [<c0635d02>] ? neigh_periodic_timer+0x13f/0x151
 [<c04341f5>] run_timer_softirq+0x14b/0x1bb
 [<c063e47a>] ? dev_watchdog+0x0/0x12d
 [<c063e47a>] ? dev_watchdog+0x0/0x12d
 [<c043076f>] __do_softirq+0x84/0x109
 [<c04306eb>] ? __do_softirq+0x0/0x109
 [<c0405eec>] do_softirq+0x77/0xdb
 [<c046417b>] ? handle_level_irq+0x0/0xbe
 [<c04303d6>] irq_exit+0x44/0x83
 [<c0405e5e>] do_IRQ+0xe7/0xfe
 [<c0404654>] common_interrupt+0x28/0x30
 =======================
---[ end trace eaf12f13083bf783 ]---



* * * * *

I probably won't report future ones to you unless something indicates a difference or a long pause intervenes.

Thank you.

-- 
Nick


      
