Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbXJaKt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbXJaKt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXJaKtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:49:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58581 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753712AbXJaKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:49:21 -0400
Date: Wed, 31 Oct 2007 10:50:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: "Suzuki Takashi" <suzuki.takashi@gmail.com>, dhowells@redhat.com,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300
 architecture to Linux kernel [try #2]
Message-ID: <20071031105048.3d0fbf42@the-village.bc.nu>
In-Reply-To: <31286.1193785564@redhat.com>
References: <b1c6420f0710301459i147f0f00n1f7009139d3ac31a@mail.gmail.com>
	<20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	<b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
	<15631.1193753689@redhat.com>
	<b1c6420f0710300810g1dbf8142j4c515a9baab4207a@mail.gmail.com>
	<27157.1193763218@redhat.com>
	<31286.1193785564@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you guarantee there won't be any non-AM33 variants of mn10300 that need
> supporting?  An AM34, perhaps?
> 
> So basically, the toolchain name should change from am33 to mn10300 by your
> argument.

Given the "i686" toolchain name is wrong (its actually i686 + cmov) there
is a ton of history for the tool chain name not matching up and its even
happened on PC - and there are tools like rpm that have to know about the
mismatches and already cope.
