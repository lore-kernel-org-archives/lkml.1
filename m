Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYE3XS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYE3XS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYE3XSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:18:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbYE3XSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:18:48 -0400
Message-ID: <48408A67.4090006@zytor.com>
Date: Fri, 30 May 2008 16:14:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Garzik <jeff@garzik.org>,
       David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>	<20080528.225826.40264516.davem@davemloft.net>	<1212041839.8888.38.camel@pasglop>	<20080529124548.GC8065@mit.edu>	<1212077700.26088.83.camel@shinybook.infradead.org>	<483F002E.5060002@garzik.org>	<1212095864.24826.2.camel@lappy.programming.kicks-ass.net>	<483F3EC4.5050700@zytor.com> <20080530103107.4f71cfe3@core>
In-Reply-To: <20080530103107.4f71cfe3@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>>
>> I tried to push for that two years ago.  I'd be more than happy to pull 
>> that out of the freezer.
> 
> Its kind of irrelevant if you need an initrd or not. The only question of
> relevance is "does it get built when I type make all". Almost all Linux
> users are using initrd without problem - because their distro ensures
> "make install" and the packaged kernels do the right thing.
> 

Obviously.  I'm equally obviously referring to klibc, which was designed 
so that the resulting vmlinux/bzImage/... file contains the necessary 
initramfs, regardless of issues like cross-compilation, draconian size 
restrictions(*), and so forth.

	-hpa

(*) Not saying that a klibc-based initramfs is necessarily smaller than 
the in-kernel code it replaces, but the total size is << than the size 
of the kernel proper, which isn't true when using a full-featured libc.
