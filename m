Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbYDXQHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbYDXQHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbYDXQHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:07:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50797 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760219AbYDXQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:07:08 -0400
Date: Thu, 24 Apr 2008 16:38:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: jakub@redhat.com, drepper@redhat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424163835.55520b5b@the-village.bc.nu>
In-Reply-To: <20080424.090008.232544945.davem@davemloft.net>
References: <20080424160352.30f2dd5b@the-village.bc.nu>
	<20080424154441.GG2255@devserv.devel.redhat.com>
	<20080424162444.1c5b9ba2@the-village.bc.nu>
	<20080424.090008.232544945.davem@davemloft.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 09:00:08 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Thu, 24 Apr 2008 16:24:44 +0100
> 
> > BTW in 4.4BSD and derivatives if I remember rightly F_CLOEXEC *is*
> > inherited across accept() so I doubt any user space software will be too
> > upset by such a shift.
> 
> It actually doesn't.
> 
> Just like in Linux, no file descriptor flags are inherited.

NDELAY certainly appears to be looking at Stevens.
