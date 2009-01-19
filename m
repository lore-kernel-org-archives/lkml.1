Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZASMPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZASMPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbZASMPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:15:05 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:55277 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbZASMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:15:01 -0500
Date: Mon, 19 Jan 2009 17:44:43 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, davem@davemloft.net,
       linville@tuxdriver.com
Subject: WARNING: at include/net/mac80211.h:1957
	minstrel_get_rate+0xa1/0x4b9 [mac80211]()
Message-ID: <20090119121443.GB5244@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am getting this regularaly on current -tip. I am connected via LEAP

------------[ cut here ]------------                                                                                                                                                                                                                                                
WARNING: at include/net/mac80211.h:1957 minstrel_get_rate+0xa1/0x4b9
[mac80211](
)                                                                                                                                                                                                                                                                                   
Hardware name: 2007CS3                                                                                                                                                                                                                                                              
Modules linked in: fuse radeon drm ipt_MASQUERADE iptable_nat nf_nat
bridge stp
bnep sco l2cap bluetooth ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_table
s ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath kvm_intel kvm uinput
snd_hda_c
odec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy
snd_seq_oss snd_
seq_midi_event snd_seq snd_seq_device snd_pcm_oss arc4 snd_mixer_oss
snd_pcm ecb
ath5k snd_timer nsc_ircc snd mac80211 irda thinkpad_acpi video rfkill
soundcore
yenta_socket i2c_i801 iTCO_wdt cfg80211 snd_page_alloc hwmon
rsrc_nonstatic iTC
O_vendor_support output pcspkr crc_ccitt joydev i2c_core [last unloaded:
scsi_wa
it_scan]                                                                                                                                                                                                                                                                            
Pid: 2353, comm: wpa_supplicant Tainted: G        W  2.6.29-rc2-tip #15                                                                                                                                                                                                             
Call Trace:                                                                                                                                                                                                                                                                         
 [<c0431946>] warn_slowpath+0x76/0xad                                                                                                                                                                                                                                               
 [<c0451e14>] ? print_lock_contention_bug+0x14/0xd7                                                                                                                                                                                                                                 
 [<c04b6b01>] ? pollwake+0x4f/0x5a                                                                                                                                                                                                                                                  
 [<c0451e14>] ? print_lock_contention_bug+0x14/0xd7                                                                                                                                                                                                                                 
 [<c0424607>] ? __wake_up+0x1a/0x40                                                                                                                                                                                                                                                 
 [<f7dad39d>] minstrel_get_rate+0xa1/0x4b9 [mac80211]                                                                                                                                                                                                                               
 [<c0424623>] ? __wake_up+0x36/0x40                                                                                                                                                                                                                                                 
 [<f7da310e>] ? invoke_tx_handlers+0x3a3/0xa2d [mac80211]                                                                                                                                                                                                                           
 [<f7d9d9da>] rate_control_get_rate+0x7e/0xbe [mac80211]                                                                                                                                                                                                                            
 [<f7da3140>] invoke_tx_handlers+0x3d5/0xa2d [mac80211]                                                                                                                                                                                                                             
 [<c0450ab3>] ? trace_hardirqs_on_caller+0x18/0x154                                                                                                                                                                                                                                 
 [<f7da2a21>] ? __ieee80211_tx_prepare+0x245/0x282 [mac80211]                                                                                                                                                                                                                       
 [<f7da4492>] ieee80211_master_start_xmit+0x380/0x4b6 [mac80211]                                                                                                                                                                                                                    
 [<c0687f99>] dev_hard_start_xmit+0x219/0x280                                                                                                                                                                                                                                       
 [<c0695a84>] __qdisc_run+0xca/0x1b2                                                                                                                                                                                                                                                
 [<c068847f>] dev_queue_xmit+0x394/0x4bb                                                                                                                                                                                                                                            
 [<f7da5f04>] ieee80211_tx_skb+0x4d/0x50 [mac80211]                                                                                                                                                                                                                                 
 [<f7d9997f>] ieee80211_send_deauth_disassoc+0xd7/0xdf [mac80211]                                                                                                                                                                                                                   
 [<f7d99a7c>] ieee80211_set_disassoc+0xf5/0x209 [mac80211]                                                                                                                                                                                                                          
 [<f7d99c81>] ieee80211_sta_req_auth+0x47/0x69 [mac80211]
 [<f7d93c44>] ieee80211_ioctl_siwgenie+0x50/0x5d [mac80211]
 [<c06e269c>] ioctl_standard_call+0x1b4/0x268
 [<c068628f>] ? dev_name_hash+0x1b/0x47
 [<c06e2263>] wext_handle_ioctl+0xe7/0x17d
 [<f7d93bf4>] ? ieee80211_ioctl_siwgenie+0x0/0x5d [mac80211]
 [<c04920be>] ? might_fault+0x83/0x85
 [<c0689e94>] dev_ioctl+0x5c6/0x5e6
 [<c067bcfb>] ? sockfd_lookup_light+0x1b/0x4e
 [<c067cc73>] ? sys_sendto+0xa9/0xc8
 [<c04cd257>] ? dnotify_parent+0x22/0x63
 [<c067b80a>] ? sock_ioctl+0x0/0x1f0
 [<c067b9ee>] sock_ioctl+0x1e4/0x1f0
 [<c067b80a>] ? sock_ioctl+0x0/0x1f0
 [<c04b4a8d>] vfs_ioctl+0x27/0x6e
 [<c04b500c>] do_vfs_ioctl+0x46f/0x4a8
 [<c067ccaf>] ? sys_send+0x1d/0x1f
 [<c04b508a>] sys_ioctl+0x45/0x5f
 [<c0403aab>] sysenter_do_call+0x12/0x3f
---[ end trace 5780832bc2c15d31 ]---

full dmesg attached. Let me know what other information I can provide.

Thanks,
-- 
regards,
Dhaval

--mP3DRpeJDSE+ciuQ
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="dmesg.tip.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWWcVqz4AL4VfgH30Sf////////6////wYELe83X2A+tb7yh9dh8u77e1lGmt
973n2wvsAKLYANd9n1Xp5bvry95eenX1b67W5btw++PQ+fPVe7Xfd3TLZvRoinXbOi2dzn3g
Lu7ve3z331rdnzeu6E+5ez1Sns1nbez2+70+6XT77r7feUPr2j7m+3RayGXbiPvq93168Hvu
nt99568+9vfczPhc919s5Ze7e2Rerr7nT731uz7tyfXXVOb3cnXkad2Vvj7vqutWOrn0721p
9DrbPbsJJE0AmjTBAEyaAEyGmJoCnkptqGEnqH6mo9JoEoTQBBNAgyp4RqniamyppnqQ8hqe
o9NR5T1NGgGmjQJICEmpppkkxkJlPVP0p+g0myp+qZD1NB6n6o9pRkDaEA9QSaUSCaAnppU3
pT9JmgnlBNqbKDEeoDTI0B6gAAIkhENDQg0CIJshT9Rk9UYD1GiNPKMQGgAASIiAIaBNGmpk
xE9T0apPKeEaYpk2mo9INGnqAAdUT+AwOBAFWBQ0hQRKSKyAi1FlIIwEWEKAgpIlCUIoLJLZ
QaSFgJSyBYMRCdQ2nIlYL3R/vwiF/NB+35d0Pu/F+j98G9cImo5/q+cbhUJT4zpyPPfq7+8U
b8XgljYqSo5t72NSZEKHvMEio5cUUbFPWRvD8xxjJ/DwinKyauTJi/dsPnl++/NLmtMZhPEi
x6fy19lAy7IVpfnK2vR6mkxZav+Io7N8TYxanNYuWZT8f5ZcMmnLT/q8FU48c8n61exQWb/t
OBI7Z6FJ0b7YQ/Hjuhmp6U1XJa84S5vCjD1a1JLWU+UJTnpQnL6nt/GMvOcThXfP33bd9HXT
Lx4O07+OcPR9N7cvoZJaDb/5UZVjox03Qf2snm+kZL/2/qVLadV3Yb9BXX18/y2evsPQl4XP
ZOlvGJreTPkcxRRz/T+DMY592kPTOY/GV8kVTC2XbWPJ/4r579e3OkLwt19/YPPeR7H4GCXU
9J+POdNoUrHlC6qqqqr+bKsq5X3VeEXy7ZJLZ2VfL3cXlXm1aPjWe55uu30Ze1y24xvmGjGO
nvott+3HDFK1vFU+rLW3/OMYxgwtO6ZjpiZA0ppP/NhmaIblRHhp+9wZXUNr3XO8tZpNRETn
XU4bbb2b+x4vZ79fDab8qPJ4x5J+Pn/Pd+WsxMTjnwknpu6cxBKjcPSH7Y24eUccI2O6j0e8
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
/xdyRThQkGcVqz4=

--mP3DRpeJDSE+ciuQ--
