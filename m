Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYEVUdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYEVUdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbYEVUd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:33:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54637 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755899AbYEVUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:33:28 -0400
Date: Thu, 22 May 2008 21:20:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080522212019.417d7adf@core>
In-Reply-To: <7207.1210802867@vena.lwn.net>
References: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org>
	<7207.1210802867@vena.lwn.net>
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

> This is all certainly doable, but it leaves me with one concern: there
> will be no signal to external module maintainers that the change needs
> to be made.  So, beyond doubt, quite a few of them will just continue to
> be shipped unfixed - and they will still run.  If any of them actually
> *need* the BKL, something awful may happen to somebody someday.

I now have a large patch and my full x86-32 build tree building without
->ioctl() in file_operations. Its a 350K patch and took all day so I'll
begin splitting it out and sending chunks to tree maintainers.

Alan
