Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXISJfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXISJfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbXISJe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:34:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35757 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756241AbXISJe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:34:58 -0400
Date: Wed, 19 Sep 2007 10:40:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: majkls <majkls@prepere.com>
Cc: bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070919104018.3a6bcfb1@the-village.bc.nu>
In-Reply-To: <46F0CD96.9030807@prepere.com>
References: <46F0CD96.9030807@prepere.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 09:19:50 +0200
majkls <majkls@prepere.com> wrote:

> Hello,
> here is an fix to an exploit (obtained somewhere in internet). This 
> exploit can workaround chroot with CAP_SYS_CHROOT. It is also possible 
> (with sufficient filedescriptor (if there is na directory fd opened in 
> root) workaround chroot with sys_fchdir. This patch fixes it.


If you have the ability to use chroot() you are root. If you are root you
can walk happily out of any chroot by a thousand other means.

Alan
