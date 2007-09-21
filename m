Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbXIUSFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbXIUSFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXIUSFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:05:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36373 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435AbXIUSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:05:10 -0400
Date: Fri, 21 Sep 2007 19:10:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: David Newall <david@davidnewall.com>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070921191012.15a0b51b@the-village.bc.nu>
In-Reply-To: <46F401D6.6060609@cfl.rr.com>
References: <46F0CD96.9030807@prepere.com>
	<20070919104018.3a6bcfb1@the-village.bc.nu>
	<46F16A0A.3070402@tmr.com>
	<20070919194559.36015307@the-village.bc.nu>
	<46F1A196.8060108@davidnewall.com>
	<46F401D6.6060609@cfl.rr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 13:39:34 -0400
Phillip Susi <psusi@cfl.rr.com> wrote:

> David Newall wrote:
> > * In particular, the superuser can escape from a =91chroot jail=92 by d=
> > oing=20
> > =91mkdir foo; chroot foo; cd ..=92.
> 
> No, he can not.

The superuser can escape that way - its expected and fine behaviour
