Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXK1NAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXK1NAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXK1NAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:00:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35534 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754167AbXK1NAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:00:04 -0500
Date: Wed, 28 Nov 2007 12:55:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Kawai@americas.sgi.com, Hidehiro <hidehiro.kawai.ez@hitachi.com>,
       Davide Libenzi <davidel@xmailserver.org>, Bron Nelson <bron@sgi.com>,
       Stephen Champion <schamp@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: Can we make application core dumps interruptible?
Message-ID: <20071128125544.3a1ac7dd@the-village.bc.nu>
In-Reply-To: <20071128123823.GB919@lnx-holt.americas.sgi.com>
References: <20071128123823.GB919@lnx-holt.americas.sgi.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> They hoped for a couple changes, one of which is a way for a SIGTERM,
> SIGKILL, or something along that line interrupting the core dump process.
> Is this the correct direction to take?  Are there any better ideas for
> handling this?

Probably. In addition current kernels allow you to pipe the core dump via
a userspace helper instead of direct to disk. That may possibly be
helpful ?

Alan
