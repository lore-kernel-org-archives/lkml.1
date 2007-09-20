Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXITFoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXITFoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXITFoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:44:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56846 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXITFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:44:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 19 Sep 2007 22:43:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nagendra Tomar <tomer_iisc@yahoo.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT
 events get missed for TCP sockets
In-Reply-To: <331107.71046.qm@web53704.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0709191701050.2989@alien.or.mcafeemobile.com>
References: <331107.71046.qm@web53704.mail.re2.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Nagendra Tomar wrote:

> Definitely not ! 
> 
> The point is that the "tcp write space available" 
> wakeup does not get called if SOCK_NOSPACE bit is not set. This was
> fine when the wakeup was merely a wakeup (since SOCK_NOSPACE bit 
> indicated that someone really cared abt the wakeup). Now after the
> introduction of callback'ed wakeups, we might have some work to
> do inside the callback even if there is nobody interested in the wakeup
> at that point of time. 
> 
> In this particular case the ep_poll_callback is not getting called and
> hence the socket fd is not getting added to the ready list.

I know, I saw the patch. I was just commenting the point where DaveM was 
heading to ;)
This things needs to be looked at a little bit more deeply.


- Davide


