Return-Path: <linux-kernel-owner+w=401wt.eu-S1766862AbXEBR3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766862AbXEBR3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766863AbXEBR3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:29:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4767 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766864AbXEBR3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:29:52 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 2 May 2007 10:29:51 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davi Arnaut <davi@haxent.com.br>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
In-Reply-To: <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>  <20070502053427.123392000@haxent.com.br>
  <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com> 
 <20070502095503.a06f5472.dada1@cosmosbay.com> 
 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com> 
 <20070502104936.674a4b54.dada1@cosmosbay.com> 
 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com> 
 <4638C37D.7050503@haxent.com.br> <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Ulrich Drepper wrote:

> > It simple as is, there is no need to overdesign.
> 
> There is no reason to go with a limited, too-simple minded design if
> we've already identified a much better design.  The fact that poll is
> used today does not excuse piling on more and more code which makes
> additional functions which don't fit into the poll framework barely
> work.  Plus, poll/epoll itself is a problem.

Is it? Please do tell me more...


- Davide


