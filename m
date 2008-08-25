Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYHYT4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYHYT4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYHYT4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:56:33 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:21610 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYHYT4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lWuScVRAUn1560/Go2kMh+Ja/TWlw8mOhfBIkm39RECAM3bdGtG3K+JFFSX1bgzpZx
         Li0VtJkN7b98D1j6NYK7eEkGcNN1hDjbkOezkJcKbxgZ3sTDEFCRLRIwi4lJ2AkC2rHH
         FHIEuLbvEE7oQ/7hLOkm9eB2fjLr4zWcmLIBo=
Message-ID: <39fd98ca0808251256nd0fc975n231b6213acb94b69@mail.gmail.com>
Date: Mon, 25 Aug 2008 20:56:31 +0100
From: "Sally-Anne Edwards" <sallyanne.edwards@googlemail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Fwd: domU lenny not working: BUG: unable to handle kernel paging request at e7437cc0
Cc: linux-kernel@vger.kernel.org, ijc@hellion.org.uk
In-Reply-To: <48B3099E.3060407@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Disposition: inline
References: <39fd98ca0808240801x7edbe0e6gf242f08de88cd92c@mail.gmail.com>
	 <39fd98ca0808240804p454faff9u289abfc074dbea3@mail.gmail.com>
	 <48B3099E.3060407@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7PJundq028070

2008/8/25 Jeremy Fitzhardinge <jeremy@goop.org>:> Sally-Anne Edwards wrote:>> Re-sending, because Gmail sent the original as HTML and the list rejected it>>>> xm-debian.cfg from http://people.debian.org/~joeyh/d-i/images/daily>> (24/08/08), options selected (ignoring the comments and the code at>> the bottom):>>>> memory = 256>> name = "debtest1">> vif = ['bridge=eth0']>> disk = ['phy:/dev/mapper/VolGroup00-debtest1,xvda,w']>>>> domU started like this:>>>> xm create -c xm-debtest1.cfg install=true>> install-installer=http://people.debian.org/~joeyh/d-i/images/daily>>>> The error:>>>> Does this happen consistently, or is it a one-off?
It is consistent - I believe Ian has seen it too
>>>   ‚€€€€€€€€€€€€€€€‡ Detecting disks and all other hardware †€€€€€€€€€€€€€€€€ƒ>>                                                                            >>                                       0%                                   >>                                                                            >>    [   97.520018] BUG: unable to handle kernel paging request at e7437cc0  >> [   97.520018] IP: [<d0837767>] :xen_blkfront:blkif_interrupt+0x5d/0x18a    >> [   97.520018] Oops: 0000 [#1] SMP €€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€…>> [   97.520018] Modules linked in: xen_blkfront(+) rsrc_nonstatic>> pcmcia_core thermal_sys xen_netfront>> [   97.520018]>> [   97.520018] Pid: 475, comm: klogd Not tainted (2.6.26-1-686-bigmem #1)>> [   97.520018] EIP: 0061:[<d0837767>] EFLAGS: 00010807 CPU: 0>> [   97.520018] EIP is at blkif_interrupt+0x5d/0x18a [xen_blkfront]>> [   97.520018] EAX: 18009c00 EBX: cf42e000 ECX: 00000200 EDX: 00000200>> [   97.520018] ESI: 00000000 EDI: cd4fe0ac EBP: ca000100 ESP: ce411f2c>> [   97.520018]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069>> [   97.520018] Process klogd (pid: 475, ti=ce410000 task=cfc60140>> task.ti=ce410000)>> [   97.520018] Stack: c01043ca 00000001 00000002 00000200 c14efd00>> 00000001 cfdfaaa0 00000000>> [   97.520018]        00000000 00000007 c0158c36 c0386ec0 00000007>> 00000000 c0386ef0 c0159ed5>> [   97.520018]        000002a0 c0386ec0 00000000 00000007 c010afd2>> 00000000 00000001 fffffffe>> [   97.520018] Call Trace:>> [   97.520018]  [<c01043ca>] xen_mc_flush+0x118/0x13b>> [   97.520018]  [<c0158c36>] handle_IRQ_event+0x23/0x51>> [   97.520018]  [<c0159ed5>] handle_level_irq+0x73/0xb6>> [   97.520018]  [<c010afd2>] do_IRQ+0x4d/0x63>> [   97.520018]  [<c022d350>] xen_evtchn_do_upcall+0x8b/0xf1>> [   97.520018]  [<c0109543>] xen_do_upcall+0x7/0xc>> [   97.520018]  =======================>> [   97.520018] Code: 8b 43 1c 89 44 24 04 89 44 24 14 e9 e2 00 00 00>> 8b 43 20 31 f6 48 23 44 24 04 6b c0 6c 8d 78 40 03 7b 24 8b 2f 69 c5>> 9c 00 00 00 <8b> 94 18 c0 00 00 00 8d 44 18 54 89 44 24 10 89 14 24 eb>> 12 8b>> [   97.520018] EIP: [<d0837767>] blkif_interrupt+0x5d/0x18a>>>> I haven't see this oops before, but I think the code in question> correlates to:>>        bret = RING_GET_RESPONSE(&info->ring, i);>        id   = bret->id;>        req  = (struct request *)info->shadow[id].request;>> which suggests the backend driver is passing back a bogus request ID.>> What's your host environment?>
Debian, freshly installed from a recent lenny test CD, amd64
Kernel is 2.6.18 amd64 from Debian etch
2.6.18-6-xen-amd64 #1 SMP Tue Aug 19 06:15:09 UTC 2008 x86_64 GNU/Linuxÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
