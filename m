Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYFEVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYFEVse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYFEVsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:48:09 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:45047 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYFEVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:48:06 -0400
Message-ID: <48485F12.2050908@mandriva.org>
Date: Fri, 06 Jun 2008 00:48:02 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
CC: Tomas Winkler <tomasw@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org> <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com> <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org>
In-Reply-To: <4848482C.2080208@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund skrev:
> Thomas Backlund skrev:
>> Tomas Winkler skrev:
>>>>
>>> Can you please verify with latest wireless-testing. git
>>> Thanks
>>> Tomas
>>
>> Yep. will do...
>>
>> I'll report back as soon as I have tried..
>>
> 
> No go...
> 
>> Jun  5 22:53:42 5720g kernel: firmware: requesting 
>> iwlwifi-4965-1.ucode                                                                                      
>> Jun  5 22:53:42 5720g kernel: Registered led device: 
>> iwl-phy0:radio                                                                                          
>> Jun  5 22:53:42 5720g kernel: Registered led device: 
>> iwl-phy0:assoc                                                                                          
>> Jun  5 22:53:42 5720g kernel: Registered led device: 
>> iwl-phy0:RX                                                                                             
>> Jun  5 22:53:42 5720g kernel: Registered led device: 
>> iwl-phy0:TX                                                                                             
>> Jun  5 22:53:42 5720g kernel: ADDRCONF(NETDEV_UP): wlan0: link is not 
>> ready                                                                                  
>> Jun  5 22:53:43 5720g kernel: BUG: unable to handle kernel NULL 
>> pointer dereference at 
>> 0000000000000000                                                      
>> Jun  5 22:53:43 5720g kernel: IP: [<ffffffffa02a6dfc>] 
>> :iwlcore:iwl_enqueue_hcmd+0x142/0x227                                                                 
>> Jun  5 22:53:43 5720g kernel: PGD 
>> 0                                                                                                                          
>> Jun  5 22:53:43 5720g kernel: Oops: 0000 [1] 
>> SMP                                                                                                             
>> Jun  5 22:53:43 5720g kernel: CPU 
>> 1                                                                                                                          
>> Jun  5 22:53:43 5720g kernel: Modules linked in: af_packet kvm_intel 
>> kvm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
>> snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 xt_tcpudp iptable_filter 
>> ip_tables x_tables binfmt_misc loop dm_mod cpufreq_ondemand 
>> cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table tifm_sd 
>> tifm_7xx1 tifm_core nvram pcmcia ohci1394 ieee1394 mmc_block arc4 ecb 
>> sr_mod cdrom crypto_blkcipher sg battery video ac yenta_socket output 
>> container firewire_ohci rsrc_nonstatic pcmcia_core sdhci firewire_core 
>> iwl4965 iwlcore mmc_core crc_itu_t i2c_i801 snd_hda_intel rfkill 
>> snd_pcsp intel_agp iTCO_wdt nsc_ircc thermal acer_wmi processor tg3 
>> iTCO_vendor_support snd_pcm joydev i2c_core snd_timer rtc_cmos button 
>> firmware_class rtc_core mac80211 led_class evdev serio_raw snd irda 
>> soundcore wmi rtc_lib crc_ccitt snd_page_alloc cfg80211 ide_generic 
>> piix ide_core ata_piix ahci libata dock sd_mod scsi_mod ext3 jbd 
>> uhci_hcd ohci_hcd ehci_hcd usbcore [last unlo
> aded: 
> nf_conntrack]                                                                                            
> 
>> Jun  5 22:53:43 5720g kernel: Pid: 10, comm: events/1 Not tainted 
>> 2.6.26-rc4-wl 
>> #1                                                                           
>> Jun  5 22:53:43 5720g kernel: RIP: 0010:[<ffffffffa02a6dfc>]  
>> [<ffffffffa02a6dfc>] 
>> :iwlcore:iwl_enqueue_hcmd+0x142/0x227                                     
>> Jun  5 22:53:43 5720g kernel: RSP: 0018:ffff81013fb15b90  EFLAGS: 
>> 00010086                                                                                   
>> Jun  5 22:53:43 5720g kernel: RAX: 0000000000000000 RBX: 
>> 0000000000000000 RCX: 
>> 0000000000000064                                                              
>> Jun  5 22:53:43 5720g kernel: RDX: 0000000000000024 RSI: 
>> 0000000000000000 RDI: 
>> ffff810139a4c578                                                              
>> Jun  5 22:53:43 5720g kernel: RBP: ffff81013fb15be0 R08: 
>> ffff810139b31200 R09: 
>> 0000000000000560                                                              
>> Jun  5 22:53:43 5720g kernel: R10: ffff81013fb15a60 R11: 
>> ffff81013fb10a78 R12: 
>> ffff810139a4c560                                                              
>> Jun  5 22:53:43 5720g kernel: R13: ffff81013bd51ba0 R14: 
>> ffff81013fb15d00 R15: 
>> 0000000000000004                                                              
>> Jun  5 22:53:43 5720g kernel: FS:  0000000000000000(0000) 
>> GS:ffff81013fab8ac0(0000) 
>> knlGS:0000000000000000                                                   
>> Jun  5 22:53:43 5720g kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
>> 000000008005003b                                                                              
>> Jun  5 22:53:43 5720g kernel: CR2: 0000000000000000 CR3: 
>> 0000000000201000 CR4: 
>> 00000000000026e0                                                              
>> Jun  5 22:53:43 5720g kernel: DR0: 0000000000000000 DR1: 
>> 0000000000000000 DR2: 
>> 0000000000000000                                                              
>> Jun  5 22:53:43 5720g kernel: DR3: 0000000000000000 DR6: 
>> 00000000ffff0ff0 DR7: 
>> 0000000000000400                                                              
>> Jun  5 22:53:43 5720g kernel: Process events/1 (pid: 10, threadinfo 
>> ffff81013fb14000, task 
>> ffff81013fb102c0)                                                 Jun  
>> 5 22:53:43 5720g kernel: Stack:  ffffffff806f8338 ffffffff8075bca0 
>> ffff81013bd52610 
>> 006881013fb10a10                                                    
>> Jun  5 22:53:43 5720g kernel:  0000000000000006 ffff81013dc86500 
>> ffff81013fb15d00 
>> ffff81013bd51ba0                                                           
>> Jun  5 22:53:43 5720g kernel:  0000000000000246 0000000000000000 
>> ffff81013fb15c60 
>> ffffffffa02a5431                                                           
>> Jun  5 22:53:43 5720g kernel: Call 
>> Trace:                                                                                                                    
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa02a5431>] 
>> :iwlcore:iwl_send_cmd_sync+0x8b/0x24e                                                                    
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff80257f1d>] ? 
>> __lock_acquire+0xbee/0xd5a                                                                             
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa02a5645>] 
>> :iwlcore:iwl_send_cmd+0x16/0x19                                                                          
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa02a84b3>] 
>> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5                                                            
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa02a855f>] 
>> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc                                                               
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa02b98ae>] 
>> :iwl4965:iwl4965_mac_set_key+0xed/0x136                                                                  
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa01762da>] 
>> :mac80211:__ieee80211_key_todo+0x109/0x203                                                               
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa017647a>] 
>> :mac80211:ieee80211_key_todo+0x17/0x25                                                                   
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa0176491>] 
>> :mac80211:key_todo+0x9/0xb                                                                               
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8024717c>] 
>> run_workqueue+0xfc/0x203                                                                                 
>> Jun  5 22:53:43 5720g kernel:  [<ffffffffa0176488>] ? 
>> :mac80211:key_todo+0x0/0xb                                                                             
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff80247363>] 
>> worker_thread+0xe0/0xf1                                                                                  
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8024ad24>] ? 
>> autoremove_wake_function+0x0/0x38                                                                      
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff80247283>] ? 
>> worker_thread+0x0/0xf1                                                                                 
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8024a9f3>] 
>> kthread+0x49/0x76                                                                                        
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8020d238>] child_rip+0xa/0x12
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8020c7cc>] ? 
>> restore_args+0x0/0x30
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8024a9aa>] ? kthread+0x0/0x76
>> Jun  5 22:53:43 5720g kernel:  [<ffffffff8020d22e>] ? child_rip+0x0/0x12
>> Jun  5 22:53:43 5720g kernel:
>> Jun  5 22:53:43 5720g kernel:
>> Jun  5 22:53:43 5720g kernel: Code: 69 c8 58 01 00 00 41 8a 06 4d 89 
>> cc 4d 03 a5 10 45 00 00 41 88 44 24 14 4c 89 e7 f3 a5 49 8d 7c 24 18 
>> 41 0f b7 4e 02 49 8b 76 18 <f3> a4 41 c6 44 24 15 00 41 0f b6 95 e4 44 
>> 00 00 89 d0 80 cc 04
>> Jun  5 22:53:43 5720g kernel: RIP  [<ffffffffa02a6dfc>] 
>> :iwlcore:iwl_enqueue_hcmd+0x142/0x227
>> Jun  5 22:53:43 5720g kernel:  RSP <ffff81013fb15b90>
>> Jun  5 22:53:43 5720g kernel: CR2: 0000000000000000
>> Jun  5 22:53:43 5720g kernel: ---[ end trace 58a672208ff93cb1 ]---
> 
> 
> And for reference I also tried 2.6.25.4 wich works as it should
> 

And I have now tested 2.6.26-rc1 wich also has the oops, so I guess it's 
bisect time...

> -- 
> Thomas
> 

