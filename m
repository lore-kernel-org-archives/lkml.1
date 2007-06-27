Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXF0Dzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXF0Dzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXF0Dzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:55:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3531 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbXF0Dze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:55:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Jun 2007 20:55:32 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Ulrich Drepper wrote:

> On 6/26/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > The following patch implements the sys_brk2() syscall, that nothing is
> > other than a sys_brk() with an extra "flags" parameter.
> 
> Shouldn't we wait for Linus' sys_indirect to arrive and make this
> another syscall which takes advantage of it?

I acutally have the code for it, but I never posted it since it did not 
receive a too warm review (and the only user was the fdmap thingy).
OTOH glibc could implement __morecore using mmap(MAP_NOZERO), and hence 
brk2() would not be needed, no?



- Davide


