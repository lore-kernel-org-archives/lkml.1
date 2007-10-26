Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbXJZAlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbXJZAlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXJZAkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:40:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50599 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752079AbXJZAkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:40:51 -0400
Date: Fri, 26 Oct 2007 01:43:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
Message-ID: <20071026014325.14f5fe1c@the-village.bc.nu>
In-Reply-To: <47213668.50907@google.com>
References: <20071025230758.945535769@crlf.corp.google.com>
	<20071026012217.4cc30390@the-village.bc.nu>
	<47213668.50907@google.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I found Chris's comment about negative block numbers, I'll send a patch 
> out for that.
> 
> You mentioned back in 99 about racing with ftruncate.  Is it sufficient 
> to mutex_lock(i_mutex) and down_read(i_alloc_sem)?

One for the fs guys. That code has changed far beyond anything I
understand any more 8)

