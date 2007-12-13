Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXLMBR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXLMBR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 20:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXLMBRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 20:17:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:5415 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXLMBRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 20:17:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XD+8/ulMGDayZBb9ktWpPvQHITI5Nn2IBGV8gNJoHyLx52VpRdvhQTDkgwKQgNI5vdOXrKN0NIl1MQNKkRihInEcIVdYzfdz1S5tBBp0Yb+zGuQM0WZfMx7kQoVLnzr4yFGKHf8ZGYFrlfIozhSJ7HwGycsaZo6RNatfYJZQ1iE=
Message-ID: <2c0942db0712121717x59af3922na33d274cf5a8c7db@mail.gmail.com>
Date: Wed, 12 Dec 2007 17:17:16 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
In-Reply-To: <200712130148.22727.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <20071213003032.547362071@mvista.com>
	 <200712130148.22727.mb@bu3sch.de>
X-Google-Sender-Auth: efd337e027362898
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 4:48 PM, Michael Buesch <mb@bu3sch.de> wrote:
> This driver is scheduled for removal, so I'd not touch it anymore
> to avoid the possibility to introduce a lastminute regression.
> The new drivers (b43 and b43legacy) have this fixed (in a different
> way by completely removing it).

Uhm, hijacking the thread a bit here, but which driver is supposed to
be supporting my 4309? Neither b43 nor b43legacy found my wireless,
and I'm not seeing its PCI ID anywhere either of those...

$ lspci -s 02:02 -v;  lspci -n -s 02:02 -v -x
02:02.0 Network controller: Broadcom Corporation BCM4309 802.11a/b/g (rev 03)
        Subsystem: Hewlett-Packard Company Unknown device 12f9
        Flags: bus master, fast devsel, latency 64, IRQ 22
        Memory at d0010000 (32-bit, non-prefetchable) [size=8K]

02:02.0 0280: 14e4:4324 (rev 03)
        Subsystem: 103c:12f9
        Flags: bus master, fast devsel, latency 64, IRQ 22
        Memory at d0010000 (32-bit, non-prefetchable) [size=8K]
00: e4 14 24 43 06 00 00 00 03 00 80 02 00 40 00 00
10: 00 00 01 d0 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 f9 12
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 01 00 00
