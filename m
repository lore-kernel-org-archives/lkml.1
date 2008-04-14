Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbYDNXJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbYDNXJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbYDNXJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:09:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53871 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYDNXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:09:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 14 Apr 2008 16:09:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@ftp.linux.org.uk>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] F_GETPATH implementation
In-Reply-To: <alpine.LFD.1.00.0804141545530.2879@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804141607190.7954@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804141227490.7954@alien.or.mcafeemobile.com>
 <alpine.LFD.1.00.0804141545530.2879@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Linus Torvalds wrote:

> 
> 
> On Mon, 14 Apr 2008, Davide Libenzi wrote:
> > Index: linux-2.6.mod/include/asm-generic/fcntl.h
> > ===================================================================
> > --- linux-2.6.mod.orig/include/asm-generic/fcntl.h	2008-04-13 15:01:09.000000000 -0700
> > +++ linux-2.6.mod/include/asm-generic/fcntl.h	2008-04-13 18:37:35.000000000 -0700
> > @@ -73,6 +73,7 @@
> >  #define F_SETSIG	10	/* for sockets. */
> >  #define F_GETSIG	11	/* for sockets. */
> >  #endif
> > +#define F_GETPATH	12
> 
> This won't work.
> 
> Different architectures have different F_xyzzy numbers, and 12 is already 
> used by various ones (it's F_SETOWN in asm-parisc/fcntl.h, for example).
> 
> I think you'd have to do it in terms of F_LINUX_SPECIFIC_BASE, like 
> F_NOTIFY is done, for example. That way you avoid these issues.

Right. Will re-munge ...



- Davide


