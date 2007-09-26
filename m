Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbXIZLeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbXIZLeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXIZLei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:34:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52761 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbXIZLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:34:37 -0400
Date: Wed, 26 Sep 2007 12:38:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <david@davidnewall.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926123833.2ed598af@the-village.bc.nu>
In-Reply-To: <46FA40F3.8010306@davidnewall.com>
References: <46F0CD96.9030807@prepere.com>
	<20070919104018.3a6bcfb1@the-village.bc.nu>
	<46F16A0A.3070402@tmr.com>
	<20070919194559.36015307@the-village.bc.nu>
	<46F1A196.8060108@davidnewall.com>
	<46F401D6.6060609@cfl.rr.com>
	<20070921191012.15a0b51b@the-village.bc.nu>
	<46F9752C.5080807@cfl.rr.com>
	<20070926002340.GL8181@ftp.linux.org.uk>
	<46FA35A6.1070400@davidnewall.com>
	<20070926122127.74cdd000@the-village.bc.nu>
	<46FA40F3.8010306@davidnewall.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've made no error.  The documentation says what it says, and what it 
> doesn't say, other than for Linux, is that there is an unspecified way 
> of breaking out.

Now see I've been working on Unix systems since 1988 or so and in that
time I've learned to read the documentation properly (you haven't) and
I've also don't security work on a pile of systems. Your assumptions and
your whole mental model of this are horribly broken.
 
> If you're so keen on trying things, then I challenge you to try it on, 
> oh, say, BSD, and then admit your error.  (Such hostile words.)

FreeBSD isn't a Unix system, and isn't compliant to the spec. Its
also still trivial to get out of a freebsd chroot using things like
ptrace. FreeBSD jails on the other hand do what you confusedly seem to
think should happen with chroot. They are seperate precisely because they
are different.

Alan
