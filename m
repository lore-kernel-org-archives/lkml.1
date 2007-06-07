Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbXFGKCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbXFGKCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXFGKCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:02:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57123 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbXFGKCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:02:23 -0400
Date: Thu, 7 Jun 2007 11:06:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070607110623.53322dae@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706061619560.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
	<20070607001932.35c9591c@the-village.bc.nu>
	<Pine.LNX.4.64.0706061619560.10383@alien.or.mcafeemobile.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think it's a matter of versioning. Many userspace libraries 
> expects their fds to be compact (for many reasons - they use select, they 
> use them to index 0-based arrays, etc...), and if the kernel suddendly 
> starts returning values in the 1<<28 up arena, they sure won't be happy.
> So I believe that the correct way is that the caller specifically selects 
> the feature, leaving the legacy fd allocation as default.

I don't understand the connection between this paragraph (with which I
agree) and the urge to add a ton of ugly syscall hacks. "Caller
specifically selects feature" - > prctl(). Libraries get unhappy ->
linker issue.
