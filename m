Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXKXHSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXKXHSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 02:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbXKXHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 02:18:46 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:45578 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbXKXHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 02:18:45 -0500
Message-ID: <4747D00D.1090603@cosmosbay.com>
Date: Sat, 24 Nov 2007 08:17:33 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv5 4/5] Allow setting O_NONBLOCK flag for new sockets
References: <200711210728.lAL7SoJO015052@devserv.devel.redhat.com>
In-Reply-To: <200711210728.lAL7SoJO015052@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 24 Nov 2007 08:17:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> This patch adds support for setting the O_NONBLOCK flag of the file
> descriptors returned by socket, socketpair, and accept.
> 

Thanks Ulrich for this v5 series. I have two more questions.

1) Can the fd passing with recvmsg() on AF_UNIX also gets O_CLOEXEC support ?

    (In my understanding, only accept(), socket(), socketcall(), socketpair()) 
are handled, so it might work on i386 (because recvmsg() is multiplexed under 
socketcall), but not on x86_64.

2) Why this O_NONBLOCK ability is needed for sockets ? Is it a security issue, 
and if yes could you remind it to me ?

Thanks

