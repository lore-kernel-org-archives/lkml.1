Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXF0QGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXF0QGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbXF0QGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:06:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2411 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbXF0QGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:06:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 09:05:59 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706270903100.32400@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Ulrich Drepper wrote:

> On 6/26/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > I acutally have the code for it, but I never posted it since it did not
> > receive a too warm review (and the only user was the fdmap thingy).
> 
> Only user of sys_indirect?  There will be quite a few right away.
> Every syscall that returns a file descriptor needs O_CLOEXEC support
> (socket, pipe, epoll_create, ...)

Ok, I'll try to add flags support to those "fd generators" over the code I 
have. That is only i386 nd x86-64 ATM (sys_indirect requires a thin asm 
wrapper - gcc asm will not do it for me).



- Davide


