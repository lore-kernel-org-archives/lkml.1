Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbXISSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbXISSk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbXISSkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:40:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58778 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751468AbXISSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:40:48 -0400
Date: Wed, 19 Sep 2007 19:45:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: majkls <majkls@prepere.com>, bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070919194559.36015307@the-village.bc.nu>
In-Reply-To: <46F16A0A.3070402@tmr.com>
References: <46F0CD96.9030807@prepere.com>
	<20070919104018.3a6bcfb1@the-village.bc.nu>
	<46F16A0A.3070402@tmr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought this was to prevent breaking out of chroot as a normal user.
> 	ie. chroot /var/myjail /bin/su - guest
> or similar.

Normal users cannot use chroot() themselves so they can't use chroot to
get back out
