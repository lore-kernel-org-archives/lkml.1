Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZLTAVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZLTAVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 19:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZLTAVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 19:21:01 -0500
Received: from mx75.mail.ru ([94.100.176.90]:64741 "EHLO mx75.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZLTAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 19:21:00 -0500
Date: Sun, 20 Dec 2009 03:26:10 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1059651918.20091220032610@mail.ru>
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re[3]: epoll'ing tcp sockets for reading
In-reply-To: <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com>
References: <1257480306.20091219150206@mail.ru>
 <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com>
 <203216314.20091220013854@mail.ru>
 <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday, December 20, 2009, 1:56:22 AM, Davide Libenzi wrote:
[trim]
> The kernel cannot make decisions based on something whose knowledge is 
> userspace bound.
I didn't mean that. I just meant it would be usefull to let the caller
of epoll know also the size of data related to specific EPOLLIN event in
some "atomic" manner immediately, because the kernel probably knows this
size already.
The same thing can approximately be "emulated" by requesting FIOREAD for
all EPOLLIN-ready sockets just after epoll returns, before any other work.
It just would look not very elegant IMHO.

> What you define as "abstract/imprecise/overcomplicated" are simply 
> decisions that you, as implementor of the upper layer protocol, have to 
> take in order to implement your userspace code.
> And I, personally, see nothing even close to be defined complicated in 
> such code.
> Whenever you're asking for an abstraction/API to implement a kind 
> of software which exist in large quantities on a system, you've got to ask 
> yourself how relevant such abstraction is at the end, if all the existing 
> software have done w/out it.
Ok, maybe that's what I should have asked at the first place. What would
you recommend as a reference implementation showing clean, efficient,
fail-safe usage of epoll with sockets?
Actually I've been googling for about 2 weeks to find some, but the results
are rather scarce and dubious.

Thank you!

Nikolai ZHUBR


> - Davide


