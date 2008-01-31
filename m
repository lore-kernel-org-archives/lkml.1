Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYAaPP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYAaPP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYAaPPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:15:48 -0500
Received: from greensrv.RZ.UniBw-Muenchen.de ([137.193.10.35]:36615 "EHLO
	GreenSrv.rz.unibw-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYAaPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:15:47 -0500
X-Remarks: If SPAM is relayed via GreenSrv.rz.unibw-muenchen.de to outside of unibw-muenchen.de, please report it to abuse@unibw-muenchen.de
Message-ID: <47A1E4AB.2010504@pc0312a.rz.unibw-muenchen.de>
Date: Thu, 31 Jan 2008 16:09:31 +0100
From: Claude Frantz <r31dmaeu@pc0312a.rz.unibw-muenchen.de>
Reply-To: r31dmaeu@pc0312b.rz.unibw-muenchen.de
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: degrading performance (NFS v.3 client)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

Please allow me to submit to you a question related to a system which
is a NFS v3 client for a Netapp server. The home directories are
NFS attached. The following behaviour occurs sometimes. The system 
becomes very slow. The load average is increasing but the most
interesting observation is the increase of the %iowait. After
reboot the system is running well for many days, then the problem 
occurs again.

Any idea ?

Thanks a lot !

Claude


kernel: 2.6.23.12-52.fc7 (Fedora 7)

"sar -q" output

07:00:01 AM   runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
07:10:02 AM         0       443      0.86      0.56      0.36
07:20:01 AM         0       481      0.40      0.47      0.40
07:30:01 AM         0       514      0.77      0.62      0.48
07:40:01 AM         0       558      0.70      0.55      0.47
07:50:01 AM         0       556      0.48      0.56      0.52
08:00:01 AM         1       575      0.60      0.56      0.53
08:10:01 AM         1       585      0.60      0.58      0.54
08:20:01 AM         0       625      0.40      0.75      0.68
08:30:01 AM         1       636      1.15      1.10      0.88
08:40:01 AM         1       774     23.99      9.99      4.21
08:50:01 AM         3       718      7.47     11.15      7.75
09:00:01 AM         6       770      8.85      6.34      6.38
09:10:01 AM         6       824     19.37     15.57     10.67
09:20:01 AM         1       864     16.30     15.40     12.98
09:30:01 AM         4       917     14.73     16.66     15.00
09:40:01 AM         4      1003     34.09     24.82     19.48
09:50:01 AM         3      1050     26.25     26.58     23.02
10:00:02 AM         2      1109     27.68     29.40     26.46
10:10:01 AM         1      1086     22.35     25.97     26.53
Average:            1       489      3.52      3.19      2.68
 
10:15:58 AM       LINUX RESTART
 
10:20:01 AM   runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
10:30:01 AM         2       817      1.77      1.74      1.17
10:40:01 AM         0       902      1.35      1.65      1.39
10:50:01 AM         2       937      1.52      2.07      1.74
11:00:01 AM         1       932      1.74      1.56      1.58
11:10:01 AM         2       972      2.17      1.74      1.62
11:20:01 AM         1      1008      1.48      1.63      1.64
11:30:02 AM         1      1018      1.85      2.09      1.90
11:40:01 AM         7      1060      5.00      8.76      6.10
11:50:01 AM         1      1087      6.17      7.47      6.76
12:00:01 PM         2      1095      3.61      4.72      5.60
12:10:01 PM         9      1107      4.66      4.66      5.19
12:20:01 PM         4      1135      3.30      3.79      4.52
12:30:01 PM         5      1215     32.66     16.54      8.98
12:40:01 PM         5      1157      3.99      7.20      8.14
12:50:01 PM         2      1155      8.45      9.40      8.76

"sar -u" output



07:00:01 AM       CPU     %user     %nice   %system   %iowait    %steal     %idle
07:10:02 AM       all      3.01      0.01      5.68      1.57      0.00     89.73
07:20:01 AM       all      3.55      0.01      6.26      1.72      0.00     88.46
07:30:01 AM       all      5.09      0.06      8.11      1.87      0.00     84.87
07:40:01 AM       all      5.00      0.00      7.83      1.52      0.00     85.65
07:50:01 AM       all      5.67      0.00      8.31      1.70      0.00     84.31
08:00:01 AM       all      3.99      0.01      7.76      1.32      0.00     86.92
08:10:01 AM       all      4.80      0.01      8.43      2.09      0.00     84.67
08:20:01 AM       all      5.19      0.00     10.86      2.13      0.00     81.82
08:30:01 AM       all      7.11      0.06     12.08      2.60      0.00     78.14
08:40:01 AM       all      9.34      0.00     17.74      5.48      0.00     67.43
08:50:01 AM       all     12.71      0.00     31.01     11.59      0.00     44.68
09:00:01 AM       all     10.32      0.00     24.47      4.45      0.00     60.76
09:10:01 AM       all     11.62      0.00     31.83     15.74      0.00     40.81
09:20:01 AM       all     13.45      0.00     32.63     15.31      0.00     38.60
09:30:01 AM       all     12.23      0.07     32.96     18.86      0.00     35.88
09:40:01 AM       all     11.45      0.00     32.75     25.88      0.00     29.93
09:50:01 AM       all     13.34      0.00     33.04     34.10      0.00     19.52
10:00:02 AM       all     13.23      0.00     33.28     34.18      0.00     19.30
10:10:01 AM       all     13.68      0.00     33.43     28.89      0.00     24.00
Average:          all      4.00      0.02      8.18      3.70      0.00     84.09
 
10:15:58 AM       LINUX RESTART
 
10:20:01 AM       CPU     %user     %nice   %system   %iowait    %steal     %idle
10:30:01 AM       all     12.93      0.00     15.33      6.77      0.00     64.98
10:40:01 AM       all     13.73      0.00     13.51      5.83      0.00     66.92
10:50:01 AM       all     12.13      0.00     17.42      5.04      0.00     65.41
11:00:01 AM       all     10.68      0.00     14.59      3.72      0.00     71.01
11:10:01 AM       all     11.27      0.00     14.40      4.71      0.00     69.62
11:20:01 AM       all     10.97      0.13     14.97      3.76      0.00     70.17
11:30:02 AM       all     13.10      0.00     18.71      3.72      0.00     64.47
11:40:01 AM       all     15.59      0.00     28.22     12.29      0.00     43.90
11:50:01 AM       all     15.07      0.00     31.73      7.00      0.00     46.20
12:00:01 PM       all     13.13      0.00     26.36      4.39      0.00     56.12
12:10:01 PM       all     14.95      0.00     27.19      6.65      0.00     51.21
12:20:01 PM       all     13.02      0.06     25.71      4.03      0.00     57.18
12:30:01 PM       all     15.18      0.00     29.02     10.21      0.00     45.58
12:40:01 PM       all     14.28      0.00     28.58      9.56      0.00     47.58
12:50:01 PM       all     15.22      0.00     34.07      7.90      0.00     42.80

"mount" options:

(rw,rsize=32768,wsize=32768,nfsvers=3,tcp,hard,nointr,timeo=600,addr=102.103.104.105)

from "sysctl -a"

sunrpc.rpc_debug = 0
sunrpc.nfs_debug = 0
sunrpc.nfsd_debug = 0
sunrpc.nlm_debug = 0
sunrpc.udp_slot_table_entries = 16
sunrpc.tcp_slot_table_entries = 16
sunrpc.min_resvport = 665
sunrpc.max_resvport = 1023
fs.nfs.nlm_grace_period = 0
fs.nfs.nlm_timeout = 10
fs.nfs.nlm_udpport = 32769
fs.nfs.nlm_tcpport = 32803
fs.nfs.nsm_use_hostnames = 0
fs.nfs.nsm_local_state = 51
fs.nfs.nfs_callback_tcpport = 0
fs.nfs.idmap_cache_timeout = 600
fs.nfs.nfs_mountpoint_timeout = 500
fs.nfs.nfs_congestion_kb = 91328
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_retrans_collapse = 1
net.ipv4.ip_forward = 0
net.ipv4.ip_default_ttl = 64
net.ipv4.ip_no_pmtu_disc = 0
net.ipv4.ip_nonlocal_bind = 0
net.ipv4.tcp_syn_retries = 5
net.ipv4.tcp_synack_retries = 5
net.ipv4.tcp_max_orphans = 32768
net.ipv4.tcp_max_tw_buckets = 180000
net.ipv4.ipfrag_high_thresh = 262144
net.ipv4.ipfrag_low_thresh = 196608
net.ipv4.ip_dynaddr = 0
net.ipv4.ipfrag_time = 30
net.ipv4.tcp_keepalive_time = 7200
net.ipv4.tcp_keepalive_probes = 9
net.ipv4.tcp_keepalive_intvl = 75
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_fin_timeout = 60
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_stdurg = 0
net.ipv4.tcp_rfc1337 = 0
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.ip_local_port_range = 32768    61000
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_errors_use_inbound_ifaddr = 0
net.ipv4.route.min_delay = 2
net.ipv4.route.max_delay = 10
net.ipv4.route.gc_thresh = 32768
net.ipv4.route.max_size = 524288
net.ipv4.route.gc_min_interval = 0
net.ipv4.route.gc_min_interval_ms = 500
net.ipv4.route.gc_timeout = 300
net.ipv4.route.gc_interval = 60
net.ipv4.route.redirect_load = 20
net.ipv4.route.redirect_number = 9
net.ipv4.route.redirect_silence = 20480
net.ipv4.route.error_cost = 1000
net.ipv4.route.error_burst = 5000
net.ipv4.route.gc_elasticity = 8
net.ipv4.route.mtu_expires = 600
net.ipv4.route.min_pmtu = 552
net.ipv4.route.min_adv_mss = 256
net.ipv4.route.secret_interval = 600
net.ipv4.igmp_max_memberships = 20
net.ipv4.igmp_max_msf = 10
net.ipv4.inet_peer_threshold = 65664
net.ipv4.inet_peer_minttl = 120
net.ipv4.inet_peer_maxttl = 600
net.ipv4.inet_peer_gc_mintime = 10
net.ipv4.inet_peer_gc_maxtime = 120
net.ipv4.tcp_orphan_retries = 0
net.ipv4.tcp_fack = 1
net.ipv4.tcp_reordering = 3
net.ipv4.tcp_ecn = 0
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_mem = 780288       1040384 1560576
net.ipv4.tcp_wmem = 4096        16384   4194304
net.ipv4.tcp_rmem = 4096        87380   4194304
net.ipv4.tcp_app_win = 31
net.ipv4.tcp_adv_win_scale = 2
net.ipv4.icmp_ratelimit = 1000
net.ipv4.icmp_ratemask = 6168
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_frto = 0
net.ipv4.tcp_frto_response = 0
net.ipv4.tcp_low_latency = 0
net.ipv4.ipfrag_secret_interval = 600
net.ipv4.ipfrag_max_dist = 64
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_tso_win_divisor = 3
net.ipv4.tcp_congestion_control = cubic
net.ipv4.tcp_abc = 0
net.ipv4.tcp_mtu_probing = 0
net.ipv4.tcp_base_mss = 512
net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.tcp_dma_copybreak = 4096
net.ipv4.tcp_slow_start_after_idle = 1
net.ipv4.cipso_cache_enable = 1
net.ipv4.cipso_cache_bucket_size = 10
net.ipv4.cipso_rbm_optfmt = 0
net.ipv4.cipso_rbm_strictvalid = 1
net.ipv4.tcp_available_congestion_control = cubic reno
net.ipv4.tcp_allowed_congestion_control = cubic reno
net.ipv4.tcp_max_ssthresh = 0
net.ipv4.neigh.default.mcast_solicit = 3
net.ipv4.neigh.default.ucast_solicit = 3
net.ipv4.neigh.default.app_solicit = 0
net.ipv4.neigh.default.retrans_time = 99
net.ipv4.neigh.default.base_reachable_time = 30
net.ipv4.neigh.default.delay_first_probe_time = 5
net.ipv4.neigh.default.gc_stale_time = 60
net.ipv4.neigh.default.unres_qlen = 3
net.ipv4.neigh.default.proxy_qlen = 64
net.ipv4.neigh.default.anycast_delay = 99
net.ipv4.neigh.default.proxy_delay = 79
net.ipv4.neigh.default.locktime = 99
net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_thresh1 = 128
net.ipv4.neigh.default.gc_thresh2 = 512
net.ipv4.neigh.default.gc_thresh3 = 1024
net.ipv4.neigh.default.retrans_time_ms = 1000
net.ipv4.neigh.default.base_reachable_time_ms = 30000
net.ipv4.neigh.eth0.mcast_solicit = 3
net.ipv4.neigh.eth0.ucast_solicit = 3
net.ipv4.neigh.eth0.app_solicit = 0
net.ipv4.neigh.eth0.retrans_time = 99
net.ipv4.neigh.eth0.base_reachable_time = 30
net.ipv4.neigh.eth0.delay_first_probe_time = 5
net.ipv4.neigh.eth0.gc_stale_time = 60
net.ipv4.neigh.eth0.unres_qlen = 3
net.ipv4.neigh.eth0.proxy_qlen = 64
net.ipv4.neigh.eth0.anycast_delay = 99
net.ipv4.neigh.eth0.proxy_delay = 79
net.ipv4.neigh.eth0.locktime = 99
net.ipv4.neigh.eth0.retrans_time_ms = 1000
net.ipv4.neigh.eth0.base_reachable_time_ms = 30000
net.ipv4.conf.all.forwarding = 0
net.ipv4.conf.all.mc_forwarding = 0
net.ipv4.conf.all.accept_redirects = 1
net.ipv4.conf.all.secure_redirects = 1
net.ipv4.conf.all.shared_media = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.all.send_redirects = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.proxy_arp = 0
net.ipv4.conf.all.medium_id = 0
net.ipv4.conf.all.bootp_relay = 0
net.ipv4.conf.all.log_martians = 0
net.ipv4.conf.all.tag = 0
net.ipv4.conf.all.arp_filter = 0
net.ipv4.conf.all.arp_announce = 0
net.ipv4.conf.all.arp_ignore = 0
net.ipv4.conf.all.arp_accept = 0
net.ipv4.conf.all.disable_xfrm = 0
net.ipv4.conf.all.disable_policy = 0
net.ipv4.conf.all.force_igmp_version = 0
net.ipv4.conf.all.promote_secondaries = 0
net.ipv4.conf.default.forwarding = 0
net.ipv4.conf.default.mc_forwarding = 0
net.ipv4.conf.default.accept_redirects = 1
net.ipv4.conf.default.secure_redirects = 1
net.ipv4.conf.default.shared_media = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.proxy_arp = 0
net.ipv4.conf.default.medium_id = 0
net.ipv4.conf.default.bootp_relay = 0
net.ipv4.conf.default.log_martians = 0
net.ipv4.conf.default.tag = 0
net.ipv4.conf.default.arp_filter = 0
net.ipv4.conf.default.arp_announce = 0
net.ipv4.conf.default.arp_ignore = 0
net.ipv4.conf.default.arp_accept = 0
net.ipv4.conf.default.disable_xfrm = 0
net.ipv4.conf.default.disable_policy = 0
net.ipv4.conf.default.force_igmp_version = 0
net.ipv4.conf.default.promote_secondaries = 0
net.ipv4.conf.eth0.forwarding = 0
net.ipv4.conf.eth0.mc_forwarding = 0
net.ipv4.conf.eth0.accept_redirects = 1
net.ipv4.conf.eth0.secure_redirects = 1
net.ipv4.conf.eth0.shared_media = 1
net.ipv4.conf.eth0.rp_filter = 1
net.ipv4.conf.eth0.send_redirects = 1
net.ipv4.conf.eth0.accept_source_route = 0
net.ipv4.conf.eth0.proxy_arp = 0
net.ipv4.conf.eth0.medium_id = 0
net.ipv4.conf.eth0.bootp_relay = 0
net.ipv4.conf.eth0.log_martians = 0
net.ipv4.conf.eth0.tag = 0
net.ipv4.conf.eth0.arp_filter = 0
net.ipv4.conf.eth0.arp_announce = 0
net.ipv4.conf.eth0.arp_ignore = 0
net.ipv4.conf.eth0.arp_accept = 0
net.ipv4.conf.eth0.disable_xfrm = 0
net.ipv4.conf.eth0.disable_policy = 0
net.ipv4.conf.eth0.force_igmp_version = 0
net.ipv4.conf.eth0.promote_secondaries = 0

