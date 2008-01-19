Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbYASUCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbYASUCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 15:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYASUCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 15:02:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57671 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbYASUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 15:02:45 -0500
Date: Sat, 19 Jan 2008 19:59:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: mingo@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 reboot: Remove inb_p usage
Message-ID: <20080119195955.624a6f78@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0801190900i11f0ff16saca04cafee0d62c3@mail.gmail.com>
References: <20080119154453.1afddbfb@lxorguk.ukuu.org.uk>
	<2c0942db0801190900i11f0ff16saca04cafee0d62c3@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stupid question from the peanut gallery: If you're going to go through
> all this, maybe it would be better to define an inline
> isa_bus_delay(void) { udelay(2); } and use that instead? I can only

There are very few places it crops up - in fact that one is the only non
pic/pit/cmos example in the core arch code.

Alan
