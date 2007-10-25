Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbXJYQKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbXJYQKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbXJYQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:10:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42337 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756141AbXJYQK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:10:29 -0400
Date: Thu, 25 Oct 2007 17:13:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux machines dieing in swap storms
Message-ID: <20071025171311.42844d17@the-village.bc.nu>
In-Reply-To: <1193325641.5776.21.camel@localhost.localdomain>
References: <1193325641.5776.21.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm seriously tempted to add a "kill the process using the most memory"
> key combination into SysRq which might let me save the desktop but won't
> help with my remote server. I could also just disable swap I guess.

For specific applications you can set resource limits, you can also set
OOM priorities in current kernels to pick who dies.

Finally you can disable overcommit and go for a rigid "no overcommit"
policy where the system will fail any memory allocation which might lead
to out of memory situations later.

Alan
