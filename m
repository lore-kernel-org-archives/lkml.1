Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXD0Vhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXD0Vhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbXD0Vhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:37:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2783 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbXD0Vhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:37:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 27 Apr 2007 14:37:29 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 12/13] signal/timer/event fds v10 - eventfd wire up x86_64
 arch ...
In-Reply-To: <20070427141941.a7891c62.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704271436210.13605@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.10599.1175553997.12>
 <20070427141941.a7891c62.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> General point: the first hunk here which wires up the 32-bit entry point
> should arguably be part of the "wire up i386" patch, not the "wire up
> x86_64" patch.
> 
> This is not a clear-cut thing.  The problem with the approach you've taken
> here is that if we wire up i386 and not x86_64's i386 table (for example)
> there are ways in which intervening patches can accidentally get i386 and
> x86_64 emulation's syscall tables out of sync.  And, of course, 32-bit
> applications will run on i386 but won't run on x86_64 or vice-versa.
> 
> So I think the best way to avoid all such problems is to always wire up
> i386 and x86_64 (both 32- and 64-bit) in the same patch.

Makes perfect sense to me. Since you've done it in -mm, I'll use your tree 
as a reference from now on.



- Davide


