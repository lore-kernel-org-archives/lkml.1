Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYHXPEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYHXPEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYHXPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:04:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:39805 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYHXPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F1qmArk+mm5MqjU8BkKSZqrB/qd/ZlVe5gM/ysr/mJ5oVTP2yPuwZ67e4eIi4tIBmz
         phq285XFbmHVMm+VMH2g4pWGLLP4hdjnn5IIkeLCJ7GU04owuOvBCqCXxbVvDfblWPbw
         uIvVpj/UtCW5YO0UdxFYy5/fgfUOYKohmUWGw=
Message-ID: <39fd98ca0808240804p454faff9u289abfc074dbea3@mail.gmail.com>
Date: Sun, 24 Aug 2008 16:04:30 +0100
From: "Sally-Anne Edwards" <sallyanne.edwards@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: domU lenny not working: BUG: unable to handle kernel paging request at e7437cc0
Cc: jeremy@goop.org, ijc@hellion.org.uk
In-Reply-To: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Disposition: inline
References: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7PC3cia020143

Re-sending, because Gmail sent the original as HTML and the list rejected it
xm-debian.cfg from http://people.debian.org/~joeyh/d-i/images/daily(24/08/08), options selected (ignoring the comments and the code atthe bottom):
memory = 256name = "debtest1"vif = ['bridge=eth0']disk = ['phy:/dev/mapper/VolGroup00-debtest1,xvda,w']
domU started like this:
xm create -c xm-debtest1.cfg install=trueinstall-installer=http://people.debian.org/~joeyh/d-i/images/daily
The error:
  ‚€€€€€€€€€€€€€€€‡ Detecting disks and all other hardware †€€€€€€€€€€€€€€€€ƒ                                                                                                                 0%                                                                                                                 [   97.520018] BUG: unable to handle kernel paging request at e7437cc0  [   97.520018] IP: [<d0837767>] :xen_blkfront:blkif_interrupt+0x5d/0x18a    [   97.520018] Oops: 0000 [#1] SMP €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€…[   97.520018] Modules linked in: xen_blkfront(+) rsrc_nonstaticpcmcia_core thermal_sys xen_netfront[   97.520018][   97.520018] Pid: 475, comm: klogd Not tainted (2.6.26-1-686-bigmem #1)[   97.520018] EIP: 0061:[<d0837767>] EFLAGS: 00010807 CPU: 0[   97.520018] EIP is at blkif_interrupt+0x5d/0x18a [xen_blkfront][   97.520018] EAX: 18009c00 EBX: cf42e000 ECX: 00000200 EDX: 00000200[   97.520018] ESI: 00000000 EDI: cd4fe0ac EBP: ca000100 ESP: ce411f2c[   97.520018]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069[   97.520018] Process klogd (pid: 475, ti=ce410000 task=cfc60140task.ti=ce410000)[   97.520018] Stack: c01043ca 00000001 00000002 00000200 c14efd0000000001 cfdfaaa0 00000000[   97.520018]        00000000 00000007 c0158c36 c0386ec0 0000000700000000 c0386ef0 c0159ed5[   97.520018]        000002a0 c0386ec0 00000000 00000007 c010afd200000000 00000001 fffffffe[   97.520018] Call Trace:[   97.520018]  [<c01043ca>] xen_mc_flush+0x118/0x13b[   97.520018]  [<c0158c36>] handle_IRQ_event+0x23/0x51[   97.520018]  [<c0159ed5>] handle_level_irq+0x73/0xb6[   97.520018]  [<c010afd2>] do_IRQ+0x4d/0x63[   97.520018]  [<c022d350>] xen_evtchn_do_upcall+0x8b/0xf1[   97.520018]  [<c0109543>] xen_do_upcall+0x7/0xc[   97.520018]  =======================[   97.520018] Code: 8b 43 1c 89 44 24 04 89 44 24 14 e9 e2 00 00 008b 43 20 31 f6 48 23 44 24 04 6b c0 6c 8d 78 40 03 7b 24 8b 2f 69 c59c 00 00 00 <8b> 94 18 c0 00 00 00 8d 44 18 54 89 44 24 10 89 14 24 eb12 8b[   97.520018] EIP: [<d0837767>] blkif_interrupt+0x5d/0x18a[xen_blkfront] SS:ESP 0069:ce411f2c[   97.520018] Kernel panic - not syncing: Fatal exception in interruptÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
