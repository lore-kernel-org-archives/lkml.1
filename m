Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYDNGAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYDNGAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYDNGAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:00:09 -0400
Received: from main.gmane.org ([80.91.229.2]:41760 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbYDNGAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:00:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: fpml <fpml@adinet.com.uy>
Subject: Re: (usb/bluez/alsa) 2.6.25-rc8 BUG: unable to handle kernel paging request
Date: Mon, 14 Apr 2008 05:55:50 +0000 (UTC)
Message-ID: <loom.20080414T054501-921@post.gmane.org>
References: <4484102.1208138456684.JavaMail.tomcat@fe-ps02>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 190.135.138.20 (Opera/9.23 (Windows NT 5.1; U; en))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fpml <at> adinet.com.uy <fpml <at> adinet.com.uy> writes:

> 
> [  912.372966] usb 1-1: USB disconnect, address 2
> [  912.374922] __tx_submit: hci0 tx submit failed urb c7237614 type 3 err -19
> [  912.375056] __tx_submit: hci0 tx submit failed urb c7237614 type 3 err -19
> [  912.377468] __tx_submit: hci0 tx submit failed urb c7237614 type 3 err -19
> [  912.381920] __tx_submit: hci0 tx submit failed urb c7237614 type 3 err -19
> [  912.599869] BUG: unable to handle kernel paging request at 31207270
> [  912.600068] IP: [<c014c55c>] __kmalloc_track_caller+0x2c/0xa0
> [  912.600244] *pde = 00000000 
> [  912.600280] Oops: 0000 [#1] 


The following "Bad page state in process 'udevd'" may be related: (different 
sessions and environment)

udev v120

============================================================
Apr 13 23:58:03 kernel: [  268.138167] usb 1-1: USB disconnect, address 2
Apr 13 23:58:03 kernel: [  268.140499] __tx_submit: hci0 tx submit failed urb 
c73d6c14 type 3 err -19
Apr 13 23:58:03 kernel: [  268.140982] __tx_submit: hci0 tx submit failed urb 
c73d6c14 type 3 err -19
Apr 13 23:58:03 kernel: [  268.144925] __tx_submit: hci0 tx submit failed urb 
c73d6c14 type 3 err -19
Apr 13 23:58:03 kernel: [  268.147443] __tx_submit: hci0 tx submit failed urb 
c73d6c14 type 3 err -19
Apr 13 23:58:03 kernel: [  268.149392] __tx_submit: hci0 tx submit failed urb 
c73f5414 type 3 err -19
Apr 13 23:58:03 kernel: [  268.152372] __tx_submit: hci0 tx submit failed urb 
c73d6c14 type 3 err -19
Apr 13 23:58:03 hcid[847]: HCI dev 0 down
Apr 13 23:58:03 hcid[847]: Stopping security manager 0
Apr 13 23:58:03 hcid[847]: Device hci0 has been disabled
Apr 13 23:58:03 hcid[847]: State changed /org/bluez/audio/device0: 
HEADSET_STATE_PLAYING -> HEADSET_STATE_DISCONNECTED
Apr 13 23:58:03 kernel: [  268.217233] Bad page state in process 'udevd'
Apr 13 23:58:03 kernel: [  268.217255] page:c10b0160 flags:0x40000000 
mapping:00000000 mapcount:0 count:-2
Apr 13 23:58:03 kernel: [  268.217466] Trying to fix it up, but a reboot is 
needed
Apr 13 23:58:03 kernel: [  268.217489] Backtrace:
Apr 13 23:58:03 kernel: [  268.217623] Pid: 258, comm: udevd Not tainted 2.6.25-
rc8 #1
Apr 13 23:58:03 kernel: [  268.217708]  [<c013c6b0>] bad_page+0x50/0x90
Apr 13 23:58:03 kernel: [  268.217816]  [<c013cae8>] 
get_page_from_freelist+0x3f8/0x420
Apr 13 23:58:03 kernel: [  268.218041]  [<c013d3c3>] __alloc_pages+0x53/0x360
Apr 13 23:58:03 kernel: [  268.218233]  [<c01112a1>] pte_alloc_one+0x11/0x40
Apr 13 23:58:03 kernel: [  268.218311]  [<c01445fd>] __pte_alloc+0xd/0x70
Apr 13 23:58:03 kernel: [  268.218413]  [<c01450f4>] copy_page_range+0x2b4/0x2d0
Apr 13 23:58:03 kernel: [  268.218747]  [<c01165db>] copy_process+0xa5b/0x1020
Apr 13 23:58:03 kernel: [  268.219036]  [<c0116c69>] do_fork+0x49/0x290
Apr 13 23:58:03 kernel: [  268.219167]  [<c0160dc3>] mntput_no_expire+0x13/0x50
Apr 13 23:58:03 kernel: [  268.219299]  [<c0102548>] sys_fork+0x18/0x20
Apr 13 23:58:03 kernel: [  268.219389]  [<c0103d92>] syscall_call+0x7/0xb
Apr 13 23:58:03 kernel: [  268.219627]  =======================
Apr 13 23:58:03 hcid[847]: HCI dev 0 unregistered
Apr 13 23:58:03 hcid[847]: Unregister path: /org/bluez/hci0
Apr 13 23:58:03 hcid[847]: Device hci0 has been removed
Apr 13 23:58:04 kernel: [  269.222032] usb 1-1: new full speed USB device using 
ohci_hcd and address 3
============================================================
Apr 14 00:14:35 kernel: [  437.747963] usb 1-1: USB disconnect, address 2
Apr 14 00:14:35 kernel: [  437.748556] __tx_submit: hci0 tx submit failed urb 
c725b414 type 3 err -19
Apr 14 00:14:35 kernel: [  437.751395] __tx_submit: hci0 tx submit failed urb 
c725b414 type 3 err -19
Apr 14 00:14:35 kernel: [  437.751596] __tx_submit: hci0 tx submit failed urb 
c725b414 type 3 err -19
Apr 14 00:14:35 kernel: [  437.754825] __tx_submit: hci0 tx submit failed urb 
c7279814 type 3 err -19
Apr 14 00:14:35 kernel: [  437.757046] __tx_submit: hci0 tx submit failed urb 
c725b414 type 3 err -19
Apr 14 00:14:35 hcid[760]: HCI dev 0 down
Apr 14 00:14:35 hcid[760]: Stopping security manager 0
Apr 14 00:14:35 hcid[760]: Device hci0 has been disabled
Apr 14 00:14:35 hcid[760]: State changed /org/bluez/audio/device0: 
HEADSET_STATE_PLAYING -> HEADSET_STATE_DISCONNECTED
Apr 14 00:14:35 kernel: [  437.869623] Bad page state in process 'udevd'
Apr 14 00:14:35 kernel: [  437.869644] page:c10d5560 flags:0x40000000 
mapping:00000000 mapcount:0 count:-1
Apr 14 00:14:35 kernel: [  437.869815] Trying to fix it up, but a reboot is 
needed
Apr 14 00:14:35 kernel: [  437.869837] Backtrace:
Apr 14 00:14:35 kernel: [  437.869967] Pid: 253, comm: udevd Not tainted 2.6.25-
rc8 #1
Apr 14 00:14:35 kernel: [  437.870013]  [<c013c6b0>] bad_page+0x50/0x90
Apr 14 00:14:35 kernel: [  437.870081]  [<c013cae8>] 
get_page_from_freelist+0x3f8/0x420
Apr 14 00:14:35 kernel: [  437.870145]  [<c013d3c3>] __alloc_pages+0x53/0x360
Apr 14 00:14:35 kernel: [  437.870202]  [<c0115720>] dup_fd+0x20/0x230
Apr 14 00:14:35 kernel: [  437.870269]  [<c013d6fe>] __get_free_pages+0x2e/0x50
Apr 14 00:14:35 kernel: [  437.870323]  [<c0111222>] pgd_alloc+0x12/0x80
Apr 14 00:14:35 kernel: [  437.870402]  [<c0115a30>] mm_init+0x90/0xc0
Apr 14 00:14:35 kernel: [  437.870461]  [<c0116451>] copy_process+0x8d1/0x1020
Apr 14 00:14:35 kernel: [  437.870526]  [<c015e9e0>] destroy_inode+0x20/0x40
Apr 14 00:14:35 kernel: [  437.870585]  [<c0116c69>] do_fork+0x49/0x290
Apr 14 00:14:35 kernel: [  437.870786]  [<c0160dc3>] mntput_no_expire+0x13/0x50
Apr 14 00:14:35 kernel: [  437.870859]  [<c0102548>] sys_fork+0x18/0x20
Apr 14 00:14:35 kernel: [  437.870911]  [<c0103d92>] syscall_call+0x7/0xb
Apr 14 00:14:35 kernel: [  437.870972]  =======================
Apr 14 00:14:35 kernel: [  438.116072] Bad page state in process 'udevd'
Apr 14 00:14:35 kernel: [  438.116094] page:c10d5560 flags:0x40000000 
mapping:00000000 mapcount:0 count:-1
Apr 14 00:14:35 kernel: [  438.116298] Trying to fix it up, but a reboot is 
needed
Apr 14 00:14:35 kernel: [  438.116321] Backtrace:
Apr 14 00:14:35 kernel: [  438.116461] Pid: 253, comm: udevd Tainted: G    B    
2.6.25-rc8 #1
Apr 14 00:14:35 kernel: [  438.116508]  [<c013c6b0>] bad_page+0x50/0x90
Apr 14 00:14:35 kernel: [  438.116578]  [<c013cae8>] 
get_page_from_freelist+0x3f8/0x420
Apr 14 00:14:35 kernel: [  438.116644]  [<c013d3c3>] __alloc_pages+0x53/0x360
Apr 14 00:14:35 kernel: [  438.116702]  [<c0115720>] dup_fd+0x20/0x230
Apr 14 00:14:35 kernel: [  438.116771]  [<c013d6fe>] __get_free_pages+0x2e/0x50
Apr 14 00:14:35 kernel: [  438.116824]  [<c0111222>] pgd_alloc+0x12/0x80
Apr 14 00:14:35 hcid[760]: HCI dev 0 unregistered
Apr 14 00:14:35 kernel: [  438.116904]  [<c0115a30>] mm_init+0x90/0xc0
Apr 14 00:14:35 kernel: [  438.116961]  [<c0116451>] copy_process+0x8d1/0x1020
Apr 14 00:14:35 kernel: [  438.117026]  [<c015e9e0>] destroy_inode+0x20/0x40
Apr 14 00:14:35 kernel: [  438.117086]  [<c0116c69>] do_fork+0x49/0x290
Apr 14 00:14:35 kernel: [  438.117148]  [<c0160dc3>] mntput_no_expire+0x13/0x50
Apr 14 00:14:35 kernel: [  438.117217]  [<c0102548>] sys_fork+0x18/0x20
Apr 14 00:14:35 hcid[760]: Unregister path: /org/bluez/hci0
Apr 14 00:14:35 hcid[760]: Device hci0 has been removed
Apr 14 00:14:35 kernel: [  438.117457]  [<c0103d92>] syscall_call+0x7/0xb
Apr 14 00:14:35 kernel: [  438.117538]  =======================
Apr 14 00:14:36 kernel: [  438.830759] usb 1-1: new full speed USB device using 
ohci_hcd and address 3
============================================================

Also happened with speaker-test:

============================================================
Apr 13 23:51:04 hcid[875]: Received AT+VGM=10
Apr 13 23:51:26 kernel: [ 2136.573775] Bad page state in process 'speaker-test'
Apr 13 23:51:26 kernel: [ 2136.573805] page:c10d4fe0 flags:0x40000000 
mapping:00000000 mapcount:0 count:-1
Apr 13 23:51:26 kernel: [ 2136.574063] Trying to fix it up, but a reboot is 
needed
Apr 13 23:51:26 kernel: [ 2136.574094] Backtrace:
Apr 13 23:51:26 kernel: [ 2136.574267] Pid: 1170, comm: speaker-test Tainted: 
P         2.6.25-rc8 #1
Apr 13 23:51:26 kernel: [ 2136.574376]  [<c013c6b0>] bad_page+0x50/0x90
Apr 13 23:51:26 kernel: [ 2136.574504]  [<c013cae8>] 
get_page_from_freelist+0x3f8/0x420
Apr 13 23:51:26 kernel: [ 2136.574688]  [<c8042293>] usb_hcd_submit_urb+0x1e3/
0x930 [usbcore]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c013d3c3>] __alloc_pages+0x53/0x360
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8154122>] __tx_submit+0x42/0xe0 
[hci_usb]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c014be0f>] __slab_alloc+0x11f/0x2f0
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c014bd48>] __slab_alloc+0x58/0x2f0
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c014c5c5>] 
__kmalloc_track_caller+0x95/0xa0
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8166eef>] hci_recv_fragment+0x12f/
0x260 [bluetooth]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8166eef>] hci_recv_fragment+0x12f/
0x260 [bluetooth]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0235b39>] __alloc_skb+0x49/0x110
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8166eef>] hci_recv_fragment+0x12f/
0x260 [bluetooth]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c81547e2>] hci_usb_rx_complete+0x122/
0x130 [hci_usb]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0159af0>] __pollwait+0x0/0xc0
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80413a1>] usb_hcd_giveback_urb+0x41/
0xa0 [usbcore]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80705c5>] finish_urb+0x55/0xb0 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80706db>] takeback_td+0xbb/0xd0 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80707d2>] dl_done_list+0xe2/0x160 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0112ffa>] enqueue_task+0xa/0x20
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8072f87>] ohci_irq+0x247/0x2d0 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c81543be>] hci_usb_tx_process+0xae/
0x2e0 [hci_usb]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80416bb>] usb_hcd_irq+0x2b/0x60 
[usbcore]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0135f05>] handle_IRQ_event+0x25/0x50
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c01371ea>] handle_level_irq+0x4a/0x90
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0106573>] do_IRQ+0x43/0x70
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0104d13>] common_interrupt+0x23/0x30
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c011bd92>] __tasklet_schedule+0x42/
0x50
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8165766>] hci_send_sco+0x96/0xe0 
[bluetooth]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c819dd9a>] sco_sock_sendmsg+0x10a/
0x150 [sco]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0230117>] sock_sendmsg+0xb7/0xf0
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c01270f0>] 
autoremove_wake_function+0x0/0x30
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c014c5c5>] 
__kmalloc_track_caller+0x95/0xa0
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8166eef>] hci_recv_fragment+0x12f/
0x260 [bluetooth]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8166eef>] hci_recv_fragment+0x12f/
0x260 [bluetooth]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c8154122>] __tx_submit+0x42/0xe0 
[hci_usb]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c81543be>] hci_usb_tx_process+0xae/
0x2e0 [hci_usb]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c022fa14>] sockfd_lookup_light+0x24/
0x50
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c0230479>] sys_sendto+0xf9/0x130
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c81546b7>] hci_usb_tx_complete+0xc7/
0xd0 [hci_usb]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80413a1>] usb_hcd_giveback_urb+0x41/
0xa0 [usbcore]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80705c5>] finish_urb+0x55/0xb0 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80706db>] takeback_td+0xbb/0xd0 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574849]  [<c80707d2>] dl_done_list+0xe2/0x160 
[ohci_hcd]
Apr 13 23:51:26 kernel: [ 2136.574850]  [<c01154c8>] task_tick_fair+0x18/0x70
Apr 13 23:51:26 kernel: [ 2136.574850]  [<c02304cd>] sys_send+0x1d/0x30
Apr 13 23:51:26 kernel: [ 2136.574850]  [<c0231280>] sys_socketcall+0x140/0x200
Apr 13 23:51:26 kernel: [ 2136.574850]  [<c015a04b>] sys_poll+0x2b/0x80
Apr 13 23:51:26 kernel: [ 2136.574850]  [<c0103d92>] syscall_call+0x7/0xb
Apr 13 23:51:26 kernel: [ 2136.574850]  =======================
============================================================


