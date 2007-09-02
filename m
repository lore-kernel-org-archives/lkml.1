Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXIBP2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXIBP2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXIBP2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:28:02 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40546 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751332AbXIBP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:28:00 -0400
Date: Sun, 2 Sep 2007 16:36:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFD] new syscalls: suspend_other/resume_other?
Message-ID: <20070902163621.547f5765@the-village.bc.nu>
In-Reply-To: <200709021704.22325.ioe-lkml@rameria.de>
References: <200709021704.22325.ioe-lkml@rameria.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 	After sucessful return of this call, the affected process 
> 	is single threaded and only the calling thread runs 
> 	in this process (==MM struct).

Not quite - vfork...

> 	This call might be restricted to the main thread.

What if differing threads have differing security credentials

And if you plan to suspend all the other threads wtf is wrong with
SIGSTOP ?
