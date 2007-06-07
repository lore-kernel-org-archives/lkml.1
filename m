Return-Path: <linux-kernel-owner+w=401wt.eu-S966048AbXFGAeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966048AbXFGAeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXFGAd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:33:56 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2230 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXFGAdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:33:55 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 Jun 2007 17:33:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <200706070229.57473.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0706061731580.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <200706070229.57473.arnd@arndb.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Arnd Bergmann wrote:

> On Thursday 07 June 2007, Davide Libenzi wrote:
> > The sys_socketcall() system call has been also changed to support
> > a new SYS_SOCKET2 indentifier.
> 
> I thought the general agreement was that sys_socketcall is a bad
> idea to start with. Is there any benefit in adding new calls to
> it instead of using a new system call number for sys_socket2 on
> all architectures?

Ohh, I didn't know it was flagged as "bad" ;) I actually had it that way, 
but then I noticed there was no __NR_socket, so I complied to the 
existing way of doing it.



- Davide


