Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbXEXJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbXEXJ4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXEXJ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:56:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48937 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756912AbXEXJ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:56:39 -0400
Date: Thu, 24 May 2007 11:01:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <Bryan.Wu@analog.com>
Subject: Re: how to allow board writers to customize driver behavior
 (watchdog here)
Message-ID: <20070524110123.09459299@the-village.bc.nu>
In-Reply-To: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> is this completely bad mojo ?  is there some other mechanism that
> provides what i want and i just dont know about it ?  or do i just
> make people change the driver to fit their application, thus throwing
> out the idea of keeping all board-specific details in just the boards
> file ...

There are two possibilities of interest I can think of (and maybe both
are useful). One is to deliver a signal to someone on expiry the other
would be to use notifier chains and export either the notifier or
add/remove operations. That allows multiple modules and users to chain
onto the expiry event

Take a look at include/linux/notifier.h

