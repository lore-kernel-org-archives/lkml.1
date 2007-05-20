Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbXETTR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbXETTR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXETTRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:17:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1123 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbXETTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:17:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 20 May 2007 12:17:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Davi Arnaut <davi@haxent.com.br>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read() call
In-Reply-To: <464F912F.3040205@haxent.com.br>
Message-ID: <Pine.LNX.4.64.0705201208190.19325@alien.or.mcafeemobile.com>
References: <464F912F.3040205@haxent.com.br>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Davi Arnaut wrote:

> Hi,
> 
> Gathering signals in bulk enables server applications to drain a signal
> queue (almost full of realtime signals) more efficiently by reducing the
> syscall and file look-up overhead.
> 
> Very similar to the sigtimedwait4() call described by Niels Provos,
> Chuck Lever, and Stephen Tweedie in a paper entitled "Analyzing the
> Overload Behavior of a Simple Web Server". The paper lists more details
> and advantages.

That paper is a pre-epoll thing. Nowadays I see no value in using RT 
signals as main event gathering mechanism ;)


> Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

The patch looks otherwise good to me, and I see no reasons why we 
shoulnd't be fetching more than one signal if available.

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


