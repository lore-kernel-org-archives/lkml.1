Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbXJCPqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbXJCPqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbXJCPqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:46:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56571 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbXJCPqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:46:44 -0400
Date: Wed, 3 Oct 2007 16:51:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
 2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003165128.46e232ab@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	<20071003084607.GC32218@elte.hu>
	<alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> and btw, there is no question what-so-ever about whether your compiler 
> might be doing a legal optimization - the compiler really is wrong, and is 

Pedant: valid. Almost all optimizations are legal, nobody has yet written
laws about compilers. Sorry but I'm forever fixing misuse of the word
"illegal" in printks, docs and the like and it gets annoying after a bit.

> total shit. You need to make a gcc bug-report. Because this is not a 
> question of "the standard is ambiguous", 

Agreed - the standard is not ambiguous here. (For reference the standard
says that a valid pointer must point at an object _OR_ one past the end
of the object (in the latter case it is not dereferencable)). So its a
compiler bug.

Alan


