Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbYEPQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbYEPQl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbYEPQd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:33:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45942 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758235AbYEPQdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:33:55 -0400
Date: Fri, 16 May 2008 17:22:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown
Message-ID: <20080516172212.4e8aafcf@core>
In-Reply-To: <16082.1210952646@vena.lwn.net>
References: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org>
	<16082.1210952646@vena.lwn.net>
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

> probably (I hope), will tell me that I've been wasting my time and that
> their code doesn't need the BKL.  In such cases, I'll gladly drop the
> associated patch.  But there's a fair amount of stuff here which clearly

You have to be careful before assuming but yes - seems sensible.

I'm currently munching my way through the watchdog drivers fixing them up
for unlocked_ioctl/BKL drops and finding various things needing fixing
anyway.

> *does* need it still.  If all seems well, maybe this tree should get into
> linux-next at some point too.

Definitely
