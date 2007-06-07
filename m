Return-Path: <linux-kernel-owner+w=401wt.eu-S966443AbXFGXnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966443AbXFGXnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762575AbXFGXns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:43:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbXFGXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:43:47 -0400
Date: Thu, 7 Jun 2007 16:42:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <Pine.LNX.4.64.0706071521490.6445@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0706071642000.4205@woody.linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706071521490.6445@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Davide Libenzi wrote:
> 
> We'd still need sys_nonseqfd() though, to move/dup legacy fds into the 
> non-sequential area.

Umm. No we don't. Because it's no more than 

	indirect_syscall(dup, FD_NONSEQ)

isn't it?

		Linus
