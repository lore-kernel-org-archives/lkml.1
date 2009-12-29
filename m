Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZL2RkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZL2RkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 12:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZL2RkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 12:40:16 -0500
Received: from smtp6.netcologne.de ([194.8.194.26]:33598 "EHLO
	smtp6.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZL2RkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 12:40:15 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 12:40:14 EST
From: Mathias Kretschmer <posting@blx4.net>
Organization: BLX4
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 2.6.32.2: WARNING: at kernel/softirq.c:143 local_bh_enable+0x83/0xa0()
Date: Tue, 29 Dec 2009 18:33:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32.2; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912291833.22222.posting@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this warning still pops up. With previous kernels (up to .31), it always 
always popped up when the first call (after boot-up) was made.

Now, it seems to be less predictable. Meaning, it does not necessarily show up 
when the first call is established, but at some later point in time.

Please let me know if you need any further info.

Cheers,

Mathias



[ 9828.655247] ------------[ cut here ]------------                                                                                                                                          
[ 9828.655267] WARNING: at kernel/softirq.c:143 local_bh_enable+0x83/0xa0()                                                                                                                  
[ 9828.655271] Hardware name: A790GXM-A                                                                                                                                                      
[ 9828.655274] Modules linked in: iscsi_trgt dummy dvb_usb_dib0700 dib7000p 
dib7000m dib0070 dvb_usb ath9k dib3000mc dib8000 mac80211 dibx000_common ath 
cfg80211 usbtouchscreen             
[ 9828.655300] Pid: 997, comm: mISDN_hfc-pci.1 Not tainted 2.6.32.2-grsec #6                                                                                                                 
[ 9828.655304] Call Trace:                                                                                                                                                                   
[ 9828.655314]  [<ffffffff8106cb73>] ? local_bh_enable+0x83/0xa0                                                                                                                             
[ 9828.655321]  [<ffffffff8106cb73>] ? local_bh_enable+0x83/0xa0                                                                                                                             
[ 9828.655328]  [<ffffffff81066984>] ? warn_slowpath_common+0x74/0xd0                                                                                                                        
[ 9828.655335]  [<ffffffff8106cb73>] ? local_bh_enable+0x83/0xa0                                                                                                                             
[ 9828.655341]  [<ffffffff815ad234>] ? sk_filter+0x44/0xa0                                                                                                                                   
[ 9828.655348]  [<ffffffff8159034d>] ? sock_queue_rcv_skb+0x5d/0x130                                                                                                                         
[ 9828.655354]  [<ffffffff814f475f>] ? mISDN_send+0x4f/0xa0                                                                                                                                  
[ 9828.655361]  [<ffffffff814f9900>] ? l2_got_ui+0x0/0x70                                                                                                                                    
[ 9828.655367]  [<ffffffff814f7ae7>] ? l2up+0x27/0x50                                                                                                                                        
[ 9828.655375]  [<ffffffff814f2fe2>] ? mISDN_FsmEvent+0x82/0x100                                                                                                                             
[ 9828.655381]  [<ffffffff814f8ff0>] ? l2_pull_iqueue+0x0/0x310                                                                                                                              
[ 9828.655387]  [<ffffffff814fbac2>] ? l2_send+0x752/0x9e0                                                                                                                                   
[ 9828.655392]  [<ffffffff814f8ff0>] ? l2_pull_iqueue+0x0/0x310                                                                                                                              
[ 9828.655399]  [<ffffffff814fd97c>] ? mgr_bcast+0x7c/0x160                                                                                                                                  
[ 9828.655404]  [<ffffffff814f6bc1>] ? mISDNStackd+0x441/0x680                                                                                                                               
[ 9828.655412]  [<ffffffff8107f9a0>] ? autoremove_wake_function+0x0/0x30                                                                                                                     
[ 9828.655418]  [<ffffffff814f6780>] ? mISDNStackd+0x0/0x680                                                                                                                                 
[ 9828.655423]  [<ffffffff8107f6b6>] ? kthread+0x96/0xa0                                                                                                                                     
[ 9828.655430]  [<ffffffff81028eda>] ? child_rip+0xa/0x20                                                                                                                                    
[ 9828.655439]  [<ffffffff81774000>] ? cpu_gdt_table+0x0/0x4000                                                                                                                              
[ 9828.655445]  [<ffffffff8107f620>] ? kthread+0x0/0xa0                                                                                                                                      
[ 9828.655450]  [<ffffffff81028ed0>] ? child_rip+0x0/0x20                                                                                                                                    
[ 9828.655454] ---[ end trace d1443398ed467875 ]---                                                                                                                                          
