Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbZEAPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbZEAPe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZEAPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:34:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:13250 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZEAPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sAtiAMrTIpNiUl2Om8xY0a1pXisI+kvT8uNn9vd8+vDbNHSBVgj8PPf7go5l3ITYmw
         L3u8bRczt1oWmUiAiSLc8r4m/Cu73GBzgbUSMEP513rgKxgG4Dsm6hrWGj4GCPiG8BFR
         wOkRbcejBM3p+nBvx53b4UFwlEnRM7CkY3rwM=
Message-ID: <49FB1697.1060909@gmail.com>
Date: Fri, 01 May 2009 17:34:47 +0200
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: reiserfs regression since rc3?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This happens since 2.6.30-rc3. Didn't happen with rc2 and previous.


REISERFS (device sda9): found reiserfs format "3.6" with standard 
journal                                                   
REISERFS (device sda9): using ordered data 
mode                                                                              

REISERFS (device sda9): journal params: device sda9, size 8192, journal 
first block 18, max trans len 1024, max batch 900, max commit age 30, 
max trans age 
30                                                                                            

REISERFS (device sda9): checking transaction log 
(sda9)                                                                     
REISERFS (device sda9): Using r5 hash to sort 
names                                                                          

------------[ cut here 
]------------                                                                                         

WARNING: at fs/namei.c:1251 
lookup_one_len+0xda/0xf0()                                                                       

Hardware name: 
MM061                                                                                                         

Modules linked in: coretemp hwmon cpufreq_ondemand fan iwl3945 iwlcore 
snd_hda_codec_idt usb_storage snd_hda_intel mac80211 snd_hda_codec 
led_class snd_pcm snd_timer snd cfg80211 psmouse evdev soundcore 
uhci_hcd ehci_hcd snd_page_alloc ac button battery 
thermal                                                                                                                  

Pid: 1551, comm: mount Not tainted 2.6.30-rc4 
#1                                                                             

Call 
Trace:                                                                                                                  

 [<ffffffff802389ba>] ? 
warn_slowpath+0xea/0x160                                                                             

 [<ffffffff80533270>] ? 
printk+0x4e/0x56                                                                                     

 [<ffffffff8030be2a>] ? 
prepare_error_buf+0x52a/0x620                                                                        

 [<ffffffff803181b2>] ? 
do_journal_end+0x292/0xf40                                                                           

 [<ffffffff803192e9>] ? 
do_journal_begin_r+0x159/0x330                                                                       

 [<ffffffff802abafa>] ? 
lookup_one_len+0xda/0xf0                                                                             

 [<ffffffff8031d0cd>] ? 
reiserfs_xattr_init+0x3d/0xb0                                                                        

 [<ffffffff8030a8b5>] ? 
reiserfs_fill_super+0x835/0xb60                                                                      

 [<ffffffff8029cc68>] ? 
kmem_cache_alloc+0x68/0xa0                                                                           

 [<ffffffff802a371a>] ? 
sget+0x3ca/0x410                                                                                     

 [<ffffffff802a4044>] ? 
get_sb_bdev+0x174/0x1a0                                                                              

 [<ffffffff8030a080>] ? 
reiserfs_fill_super+0x0/0xb60                                                                        

 [<ffffffff802a2ab6>] ? 
vfs_kern_mount+0x56/0xd0                                                                             

 [<ffffffff802a2b93>] ? 
do_kern_mount+0x53/0x120                                                                             

 [<ffffffff802bbcca>] ? 
do_mount+0x2ba/0x8c0                                                                                 

 [<ffffffff802bc39d>] ? 
sys_mount+0xcd/0x100                                                                                 

 [<ffffffff8020b42b>] ? 
system_call_fastpath+0x16/0x1b                                                                       

---[ end trace 58726f3f2c919bd3 ]---

Entry in /etc/fstab:
/dev/sda9        /usr/portage    reiserfs        noatime,notail  0 0

Sorry if it's been reported already, I couldn't find it.
I'm not subscribed so please CC me if you answer.
Thanks.

Mikko
