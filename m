Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbZFXOQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbZFXOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZFXOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:16:19 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57322 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbZFXOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=prQLxHRxTT0eDeUe3nHtXYZMqKB2B4h6uQ9RvJ/jR6CFtzYQBwwEcOBoSiyJz7NlFK
         QGSZ6buVJt/xT9gaWKcyFK0nF2d5WgRuWRVZkvQLnz6Nnupziuiby7/OjLbIkS3TxjTs
         6Ih0KqqhVlSpYjr7P9iPPKobOonbdxR3yh4lI=
MIME-Version: 1.0
Date: Wed, 24 Jun 2009 16:16:19 +0200
Message-ID: <4e5e476b0906240716q6638a0eevad790c439f5bdae6@mail.gmail.com>
Subject: What is swapper, and why it is causing so many wakeups?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: multipart/mixed; boundary=00504502c97a4b6aa0046d18c0ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502c97a4b6aa0046d18c0ef
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
my /proc/timer_stats shows a lot of activity due to 'swapper'.
It is currently the main cause of wakeups on my netbook, an acer
aspire one with Atom N270 cpu.
The funny thing is that I have no swap partition, so I don't think
swapper should have so much work to do.
Is there a way to reduce its activity?

Timer Stats Version: v0.2
Sample period: 298.025 s
 23207,     0 swapper          hrtimer_start_range_ns (tick_sched_timer)
 23806,     0 swapper          hrtimer_start_range_ns (tick_sched_timer)
  651,  2615 lxterminal       hrtimer_start_range_ns (hrtimer_wakeup)
3275D,  1520 S50cpufreq       cpufreq_governor_dbs (delayed_work_timer_fn)
3373D,  1520 S50cpufreq       cpufreq_governor_dbs (delayed_work_timer_fn)
   60,     0 swapper          page_writeback_init (wb_timer_fn)
   60,  2582 xscreensaver     hrtimer_start_range_ns (hrtimer_wakeup)
   21,  2139 X                hrtimer_start (it_real_fn)
 1684,     0 swapper          hrtimer_start (tick_sched_timer)
  279,  2139 X                queue_delayed_work (delayed_work_timer_fn)
  297,  2585 lxpanel          hrtimer_start_range_ns (hrtimer_wakeup)
  298,  2272 ifplugd          hrtimer_start_range_ns (hrtimer_wakeup)
  149,  2156 ifplugd          hrtimer_start_range_ns (hrtimer_wakeup)
   37,  2139 X                hrtimer_start_range_ns (hrtimer_wakeup)
   30,  2221 ip               ath5k_start (ath5k_calibrate)
 1040,     0 swapper          hrtimer_start (tick_sched_timer)
   38,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
   50,  2156 ifplugd          __netdev_watchdog_up (dev_watchdog)
   75,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
 284D,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
 273D,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
  149,  2545 net_applet       hrtimer_start_range_ns (hrtimer_wakeup)
  149,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
  149,     1 swapper          schedule_delayed_work_on (delayed_work_timer_fn)
   60,     1 init             hrtimer_start_range_ns (hrtimer_wakeup)
   24,  1321 btrfs-transacti  schedule_timeout (process_timeout)
  137,     1 swapper          enqueue_task_rt (sched_rt_period_timer)
   74,  2594 menu-cached      hrtimer_start_range_ns (hrtimer_wakeup)
   48,  2269 wpa_supplicant   hrtimer_start_range_ns (hrtimer_wakeup)
 1296,   484 phy0             queue_delayed_work (delayed_work_timer_fn)
   30,     1 swapper          sta_info_start (sta_info_cleanup)
    2,     0 swapper          neigh_add_timer (neigh_timer_handler)
    3,  1276 mount            start_this_handle (commit_timeout)
    1,  2998 iwgetid          do_acct_process (acct_timeout)
    5,     1 swapper          queue_delayed_work (delayed_work_timer_fn)
    2,   479 async/1          scsi_request_fn (blk_rq_timed_out_timer)
    5,  1708 crond            hrtimer_start_range_ns (hrtimer_wakeup)
   10,  1564 syslogd          hrtimer_start (it_real_fn)
    9,  1756 hald             hrtimer_start_range_ns (hrtimer_wakeup)
    1,     1 swapper          inet_init (inet_frag_secret_rebuild)
    1,     1 swapper          flow_cache_init (flow_cache_new_hashrnd)
    1,     1 swapper          ipv6_frag_init (inet_frag_secret_rebuild)
    3,     0 swapper          addrconf_verify (addrconf_verify)
    1,     1 swapper          queue_delayed_work (delayed_work_timer_fn)
    1,  3017 modprobe         do_acct_process (acct_timeout)
    1,   252 ksuspend_usbd    schedule_timeout (process_timeout)
    1,   252 ksuspend_usbd    schedule_timeout (process_timeout)
    1,   252 ksuspend_usbd    schedule_timeout (process_timeout)
    8,   258 khubd            schedule_timeout (process_timeout)
  110,     0 swapper          ehci_work (ehci_watchdog)
    2,   258 khubd            schedule_timeout (process_timeout)
    2,   258 khubd            schedule_timeout (process_timeout)
    1,  3044 usb-stor-scan    schedule_timeout (process_timeout)
    1,  3058 scsi_scan_2      scsi_request_fn (blk_rq_timed_out_timer)
    4,  3043 usb-storage      schedule_timeout (process_timeout)
    1,  3043 usb-storage      schedule_timeout (process_timeout)
    1,  3043 usb-storage      schedule_timeout (process_timeout)
    1,   258 khubd            schedule_timeout (process_timeout)
    1,  3070 usb-stor-scan    schedule_timeout (process_timeout)
    1,  3086 async/0          schedule_timeout (process_timeout)
    1,  3084 scsi_scan_3      scsi_request_fn (blk_rq_timed_out_timer)
    1,  3042 pam_console_app  do_acct_process (acct_timeout)
    2,     1 swapper          inet_initpeers (peer_check_expire)
    1,  3144 iwgetid          do_acct_process (acct_timeout)
    1,  1312 btrfs-endio-met  schedule_timeout (process_timeout)
    1,  3151 modprobe         do_acct_process (acct_timeout)
    9,  2139 X                vt_ioctl (kd_nosound)
    1,  3176 modprobe         do_acct_process (acct_timeout)
   10,  3235 iwlist           hrtimer_start_range_ns (hrtimer_wakeup)
    8,  2615 lxterminal       hrtimer_start_range_ns (hrtimer_wakeup)
    1,  3003 less             do_acct_process (acct_timeout)
61320 total events, 205.994 events/sec

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

--00504502c97a4b6aa0046d18c0ef
Content-Type: application/octet-stream; name=timer_stats
Content-Disposition: attachment; filename=timer_stats
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwc49byb0

VGltZXIgU3RhdHMgVmVyc2lvbjogdjAuMgpTYW1wbGUgcGVyaW9kOiAyOTguMDI1IHMKIDIzMjA3
LCAgICAgMCBzd2FwcGVyICAgICAgICAgIGhydGltZXJfc3RhcnRfcmFuZ2VfbnMgKHRpY2tfc2No
ZWRfdGltZXIpCiAyMzgwNiwgICAgIDAgc3dhcHBlciAgICAgICAgICBocnRpbWVyX3N0YXJ0X3Jh
bmdlX25zICh0aWNrX3NjaGVkX3RpbWVyKQogIDY1MSwgIDI2MTUgbHh0ZXJtaW5hbCAgICAgICBo
cnRpbWVyX3N0YXJ0X3JhbmdlX25zIChocnRpbWVyX3dha2V1cCkKMzI3NUQsICAxNTIwIFM1MGNw
dWZyZXEgICAgICAgY3B1ZnJlcV9nb3Zlcm5vcl9kYnMgKGRlbGF5ZWRfd29ya190aW1lcl9mbikK
MzM3M0QsICAxNTIwIFM1MGNwdWZyZXEgICAgICAgY3B1ZnJlcV9nb3Zlcm5vcl9kYnMgKGRlbGF5
ZWRfd29ya190aW1lcl9mbikKICAgNjAsICAgICAwIHN3YXBwZXIgICAgICAgICAgcGFnZV93cml0
ZWJhY2tfaW5pdCAod2JfdGltZXJfZm4pCiAgIDYwLCAgMjU4MiB4c2NyZWVuc2F2ZXIgICAgIGhy
dGltZXJfc3RhcnRfcmFuZ2VfbnMgKGhydGltZXJfd2FrZXVwKQogICAyMSwgIDIxMzkgWCAgICAg
ICAgICAgICAgICBocnRpbWVyX3N0YXJ0IChpdF9yZWFsX2ZuKQogMTY4NCwgICAgIDAgc3dhcHBl
ciAgICAgICAgICBocnRpbWVyX3N0YXJ0ICh0aWNrX3NjaGVkX3RpbWVyKQogIDI3OSwgIDIxMzkg
WCAgICAgICAgICAgICAgICBxdWV1ZV9kZWxheWVkX3dvcmsgKGRlbGF5ZWRfd29ya190aW1lcl9m
bikKICAyOTcsICAyNTg1IGx4cGFuZWwgICAgICAgICAgaHJ0aW1lcl9zdGFydF9yYW5nZV9ucyAo
aHJ0aW1lcl93YWtldXApCiAgMjk4LCAgMjI3MiBpZnBsdWdkICAgICAgICAgIGhydGltZXJfc3Rh
cnRfcmFuZ2VfbnMgKGhydGltZXJfd2FrZXVwKQogIDE0OSwgIDIxNTYgaWZwbHVnZCAgICAgICAg
ICBocnRpbWVyX3N0YXJ0X3JhbmdlX25zIChocnRpbWVyX3dha2V1cCkKICAgMzcsICAyMTM5IFgg
ICAgICAgICAgICAgICAgaHJ0aW1lcl9zdGFydF9yYW5nZV9ucyAoaHJ0aW1lcl93YWtldXApCiAg
IDMwLCAgMjIyMSBpcCAgICAgICAgICAgICAgIGF0aDVrX3N0YXJ0IChhdGg1a19jYWxpYnJhdGUp
CiAxMDQwLCAgICAgMCBzd2FwcGVyICAgICAgICAgIGhydGltZXJfc3RhcnQgKHRpY2tfc2NoZWRf
dGltZXIpCiAgIDM4LCAgICAgMSBzd2FwcGVyICAgICAgICAgIG5laWdoX3RhYmxlX2luaXRfbm9f
bmV0bGluayAobmVpZ2hfcGVyaW9kaWNfdGltZXIpCiAgIDUwLCAgMjE1NiBpZnBsdWdkICAgICAg
ICAgIF9fbmV0ZGV2X3dhdGNoZG9nX3VwIChkZXZfd2F0Y2hkb2cpCiAgIDc1LCAgICAgMSBzd2Fw
cGVyICAgICAgICAgIG5laWdoX3RhYmxlX2luaXRfbm9fbmV0bGluayAobmVpZ2hfcGVyaW9kaWNf
dGltZXIpCiAyODRELCAgICAgMSBzd2FwcGVyICAgICAgICAgIHNjaGVkdWxlX2RlbGF5ZWRfd29y
a19vbiAoZGVsYXllZF93b3JrX3RpbWVyX2ZuKQogMjczRCwgICAgIDEgc3dhcHBlciAgICAgICAg
ICBzY2hlZHVsZV9kZWxheWVkX3dvcmtfb24gKGRlbGF5ZWRfd29ya190aW1lcl9mbikKICAxNDks
ICAyNTQ1IG5ldF9hcHBsZXQgICAgICAgaHJ0aW1lcl9zdGFydF9yYW5nZV9ucyAoaHJ0aW1lcl93
YWtldXApCiAgMTQ5LCAgICAgMSBzd2FwcGVyICAgICAgICAgIHNjaGVkdWxlX2RlbGF5ZWRfd29y
a19vbiAoZGVsYXllZF93b3JrX3RpbWVyX2ZuKQogIDE0OSwgICAgIDEgc3dhcHBlciAgICAgICAg
ICBzY2hlZHVsZV9kZWxheWVkX3dvcmtfb24gKGRlbGF5ZWRfd29ya190aW1lcl9mbikKICAgNjAs
ICAgICAxIGluaXQgICAgICAgICAgICAgaHJ0aW1lcl9zdGFydF9yYW5nZV9ucyAoaHJ0aW1lcl93
YWtldXApCiAgIDI0LCAgMTMyMSBidHJmcy10cmFuc2FjdGkgIHNjaGVkdWxlX3RpbWVvdXQgKHBy
b2Nlc3NfdGltZW91dCkKICAxMzcsICAgICAxIHN3YXBwZXIgICAgICAgICAgZW5xdWV1ZV90YXNr
X3J0IChzY2hlZF9ydF9wZXJpb2RfdGltZXIpCiAgIDc0LCAgMjU5NCBtZW51LWNhY2hlZCAgICAg
IGhydGltZXJfc3RhcnRfcmFuZ2VfbnMgKGhydGltZXJfd2FrZXVwKQogICA0OCwgIDIyNjkgd3Bh
X3N1cHBsaWNhbnQgICBocnRpbWVyX3N0YXJ0X3JhbmdlX25zIChocnRpbWVyX3dha2V1cCkKIDEy
OTYsICAgNDg0IHBoeTAgICAgICAgICAgICAgcXVldWVfZGVsYXllZF93b3JrIChkZWxheWVkX3dv
cmtfdGltZXJfZm4pCiAgIDMwLCAgICAgMSBzd2FwcGVyICAgICAgICAgIHN0YV9pbmZvX3N0YXJ0
IChzdGFfaW5mb19jbGVhbnVwKQogICAgMiwgICAgIDAgc3dhcHBlciAgICAgICAgICBuZWlnaF9h
ZGRfdGltZXIgKG5laWdoX3RpbWVyX2hhbmRsZXIpCiAgICAzLCAgMTI3NiBtb3VudCAgICAgICAg
ICAgIHN0YXJ0X3RoaXNfaGFuZGxlIChjb21taXRfdGltZW91dCkKICAgIDEsICAyOTk4IGl3Z2V0
aWQgICAgICAgICAgZG9fYWNjdF9wcm9jZXNzIChhY2N0X3RpbWVvdXQpCiAgICA1LCAgICAgMSBz
d2FwcGVyICAgICAgICAgIHF1ZXVlX2RlbGF5ZWRfd29yayAoZGVsYXllZF93b3JrX3RpbWVyX2Zu
KQogICAgMiwgICA0NzkgYXN5bmMvMSAgICAgICAgICBzY3NpX3JlcXVlc3RfZm4gKGJsa19ycV90
aW1lZF9vdXRfdGltZXIpCiAgICA1LCAgMTcwOCBjcm9uZCAgICAgICAgICAgIGhydGltZXJfc3Rh
cnRfcmFuZ2VfbnMgKGhydGltZXJfd2FrZXVwKQogICAxMCwgIDE1NjQgc3lzbG9nZCAgICAgICAg
ICBocnRpbWVyX3N0YXJ0IChpdF9yZWFsX2ZuKQogICAgOSwgIDE3NTYgaGFsZCAgICAgICAgICAg
ICBocnRpbWVyX3N0YXJ0X3JhbmdlX25zIChocnRpbWVyX3dha2V1cCkKICAgIDEsICAgICAxIHN3
YXBwZXIgICAgICAgICAgaW5ldF9pbml0IChpbmV0X2ZyYWdfc2VjcmV0X3JlYnVpbGQpCiAgICAx
LCAgICAgMSBzd2FwcGVyICAgICAgICAgIGZsb3dfY2FjaGVfaW5pdCAoZmxvd19jYWNoZV9uZXdf
aGFzaHJuZCkKICAgIDEsICAgICAxIHN3YXBwZXIgICAgICAgICAgaXB2Nl9mcmFnX2luaXQgKGlu
ZXRfZnJhZ19zZWNyZXRfcmVidWlsZCkKICAgIDMsICAgICAwIHN3YXBwZXIgICAgICAgICAgYWRk
cmNvbmZfdmVyaWZ5IChhZGRyY29uZl92ZXJpZnkpCiAgICAxLCAgICAgMSBzd2FwcGVyICAgICAg
ICAgIHF1ZXVlX2RlbGF5ZWRfd29yayAoZGVsYXllZF93b3JrX3RpbWVyX2ZuKQogICAgMSwgIDMw
MTcgbW9kcHJvYmUgICAgICAgICBkb19hY2N0X3Byb2Nlc3MgKGFjY3RfdGltZW91dCkKICAgIDEs
ICAgMjUyIGtzdXNwZW5kX3VzYmQgICAgc2NoZWR1bGVfdGltZW91dCAocHJvY2Vzc190aW1lb3V0
KQogICAgMSwgICAyNTIga3N1c3BlbmRfdXNiZCAgICBzY2hlZHVsZV90aW1lb3V0IChwcm9jZXNz
X3RpbWVvdXQpCiAgICAxLCAgIDI1MiBrc3VzcGVuZF91c2JkICAgIHNjaGVkdWxlX3RpbWVvdXQg
KHByb2Nlc3NfdGltZW91dCkKICAgIDgsICAgMjU4IGtodWJkICAgICAgICAgICAgc2NoZWR1bGVf
dGltZW91dCAocHJvY2Vzc190aW1lb3V0KQogIDExMCwgICAgIDAgc3dhcHBlciAgICAgICAgICBl
aGNpX3dvcmsgKGVoY2lfd2F0Y2hkb2cpCiAgICAyLCAgIDI1OCBraHViZCAgICAgICAgICAgIHNj
aGVkdWxlX3RpbWVvdXQgKHByb2Nlc3NfdGltZW91dCkKICAgIDIsICAgMjU4IGtodWJkICAgICAg
ICAgICAgc2NoZWR1bGVfdGltZW91dCAocHJvY2Vzc190aW1lb3V0KQogICAgMSwgIDMwNDQgdXNi
LXN0b3Itc2NhbiAgICBzY2hlZHVsZV90aW1lb3V0IChwcm9jZXNzX3RpbWVvdXQpCiAgICAxLCAg
MzA1OCBzY3NpX3NjYW5fMiAgICAgIHNjc2lfcmVxdWVzdF9mbiAoYmxrX3JxX3RpbWVkX291dF90
aW1lcikKICAgIDQsICAzMDQzIHVzYi1zdG9yYWdlICAgICAgc2NoZWR1bGVfdGltZW91dCAocHJv
Y2Vzc190aW1lb3V0KQogICAgMSwgIDMwNDMgdXNiLXN0b3JhZ2UgICAgICBzY2hlZHVsZV90aW1l
b3V0IChwcm9jZXNzX3RpbWVvdXQpCiAgICAxLCAgMzA0MyB1c2Itc3RvcmFnZSAgICAgIHNjaGVk
dWxlX3RpbWVvdXQgKHByb2Nlc3NfdGltZW91dCkKICAgIDEsICAgMjU4IGtodWJkICAgICAgICAg
ICAgc2NoZWR1bGVfdGltZW91dCAocHJvY2Vzc190aW1lb3V0KQogICAgMSwgIDMwNzAgdXNiLXN0
b3Itc2NhbiAgICBzY2hlZHVsZV90aW1lb3V0IChwcm9jZXNzX3RpbWVvdXQpCiAgICAxLCAgMzA4
NiBhc3luYy8wICAgICAgICAgIHNjaGVkdWxlX3RpbWVvdXQgKHByb2Nlc3NfdGltZW91dCkKICAg
IDEsICAzMDg0IHNjc2lfc2Nhbl8zICAgICAgc2NzaV9yZXF1ZXN0X2ZuIChibGtfcnFfdGltZWRf
b3V0X3RpbWVyKQogICAgMSwgIDMwNDIgcGFtX2NvbnNvbGVfYXBwICBkb19hY2N0X3Byb2Nlc3Mg
KGFjY3RfdGltZW91dCkKICAgIDIsICAgICAxIHN3YXBwZXIgICAgICAgICAgaW5ldF9pbml0cGVl
cnMgKHBlZXJfY2hlY2tfZXhwaXJlKQogICAgMSwgIDMxNDQgaXdnZXRpZCAgICAgICAgICBkb19h
Y2N0X3Byb2Nlc3MgKGFjY3RfdGltZW91dCkKICAgIDEsICAxMzEyIGJ0cmZzLWVuZGlvLW1ldCAg
c2NoZWR1bGVfdGltZW91dCAocHJvY2Vzc190aW1lb3V0KQogICAgMSwgIDMxNTEgbW9kcHJvYmUg
ICAgICAgICBkb19hY2N0X3Byb2Nlc3MgKGFjY3RfdGltZW91dCkKICAgIDksICAyMTM5IFggICAg
ICAgICAgICAgICAgdnRfaW9jdGwgKGtkX25vc291bmQpCiAgICAxLCAgMzE3NiBtb2Rwcm9iZSAg
ICAgICAgIGRvX2FjY3RfcHJvY2VzcyAoYWNjdF90aW1lb3V0KQogICAxMCwgIDMyMzUgaXdsaXN0
ICAgICAgICAgICBocnRpbWVyX3N0YXJ0X3JhbmdlX25zIChocnRpbWVyX3dha2V1cCkKICAgIDgs
ICAyNjE1IGx4dGVybWluYWwgICAgICAgaHJ0aW1lcl9zdGFydF9yYW5nZV9ucyAoaHJ0aW1lcl93
YWtldXApCiAgICAxLCAgMzAwMyBsZXNzICAgICAgICAgICAgIGRvX2FjY3RfcHJvY2VzcyAoYWNj
dF90aW1lb3V0KQo2MTMyMCB0b3RhbCBldmVudHMsIDIwNS45OTQgZXZlbnRzL3NlYwo=
--00504502c97a4b6aa0046d18c0ef--
