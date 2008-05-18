Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYERKUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYERKUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYERKUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:20:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56572 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbYERKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:20:03 -0400
Date: Sun, 18 May 2008 11:08:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Alan Cox <alan@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bug in `tty: BKL pushdown'?
Message-ID: <20080518110812.5485de20@core>
In-Reply-To: <87wslsuzk8.fsf@saeurebad.de>
References: <87wslsuzk8.fsf@saeurebad.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have yet to test a current kernel version with this patch reverted
> because I am too sleepy right now to solve the conflicts.

That wouldn't actually be a useful test if you did as the locking changes
would then bite you. The patch in question should just be a locking
change so short of compiler bugs ought to be fairly easy to audit. I will
dig into it next week.

Alan
