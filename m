Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYBKL7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYBKL7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYBKL6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:58:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55164 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752520AbYBKL6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:58:35 -0500
Date: Mon, 11 Feb 2008 11:50:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com,
       alan@redhat.com, jeff@garzik.org
Subject: Re: [PATCH] libata: Forcing PIO0 mode on reset must not freeze
 system
Message-ID: <20080211115050.77feb1af@core>
In-Reply-To: <47AFB4DB.1000204@gmail.com>
References: <20080210195556.GA5261@homac>
	<47AFB4DB.1000204@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the above example, even the reset sequence itself can cause hang if
> the hardware is implemented slightly differently.  The reason why
> set_piomode() locks up but reset sequence doesn't is simple dumb luck.
> I think the proper fix is to tell libata to detach the cdrom before
> undocking.

Just a thought but which ICH variant is this. For the older ones we have
to turn IORDY off in software before an eject and they cannot fully
support hot unplug

Alan

