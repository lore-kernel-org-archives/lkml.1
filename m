Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbXGARJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbXGARJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXGARJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 13:09:09 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1174 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXGARJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 13:09:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 1 Jul 2007 10:09:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
In-Reply-To: <a36005b50707010925k5c936c1ch2238b560c595a833@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707011003510.7547@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0> 
 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com> 
 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com> 
 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com> 
 <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com>
 <a36005b50707010925k5c936c1ch2238b560c595a833@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007, Ulrich Drepper wrote:

> On 6/30/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > This is how all those overloaded syscalls looks like, BTW:
> > [...]
> > How would you do that with a single shared strcture, w/out adding in all
> > signal paths the knowledge of the structure?
> 
> You said it yourself: each individual wrapper would look like this.
> Generalization really isn't possible, you'll have each wrapper syscall
> looking different.  This means there is no reason to try coming up
> with some overly complicated data structure which would only be useful
> if the processing of that data structure could be centralized.

With the current API design you'd able to easily confine the "pre" code 
inside the "set" function, and the "post" code inside the "unset" 
function. It looks pretty clean to me, and allows to limit the knowledge 
of sys_indirect, the more as possible inside kernel/indirect.c.



- Davide


