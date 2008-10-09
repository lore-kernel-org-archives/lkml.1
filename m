Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYJIJSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYJIJSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYJIJSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:18:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34231 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468AbYJIJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:18:24 -0400
Date: Thu, 9 Oct 2008 10:18:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: chri <chripell@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] max3100 driver
Message-ID: <20081009101822.54acd701@lxorguk.ukuu.org.uk>
In-Reply-To: <cabda6420810082330i6d013e18o72eac3cb869b1e4e@mail.gmail.com>
References: <1221895208650-git-send-email-chripell@gmail.com>
	<20080920151149.21dbad1d@lxorguk.ukuu.org.uk>
	<cabda6420810082330i6d013e18o72eac3cb869b1e4e@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If there has been a hangup the port.tty will be NULL...
> >
> 
> I check against NULL. But let me ask again: the other drivers (for
> example SA1100) don't do it. How they avoid the nasty NULL pointer
> dereference?

Some drives keep the tty pointer and deliver data to closed ttys wrongly,
others do careful locking, others are just broken.


> Sorry again for not having replied before resending the patch.

No problem
