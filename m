Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbXJJMKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbXJJMKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXJJMKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:10:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38236 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750807AbXJJMKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:10:48 -0400
Date: Wed, 10 Oct 2007 13:15:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "sugaken.r3@gmail.com" <sugaken.r3@gmail.com>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softdog - panic instead of reboot, kernel 2.6.22.9
Message-ID: <20071010131543.7da15e67@the-village.bc.nu>
In-Reply-To: <7DC80B08BC13EBsugaken.r3@gmail.com>
References: <7DC80B08BC13EBsugaken.r3@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> analysis.  Provided that timer interrupts are not blocked, this patch 
> might enable them to get a crash dump in such a situation by activating 
> softdog.

You want the NMI based anti lockup stuff for that. If the box locks up
then generally softdog will fail. The NMI based debug
(CONFIG_DETECT_SOFTLOCKUP) is the option you want.

