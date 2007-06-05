Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbXFECib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbXFECib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 22:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759205AbXFECiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 22:38:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2278 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbXFECiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 22:38:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 4 Jun 2007 19:38:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
 woes
In-Reply-To: <1181009413.31677.117.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
 <1181009413.31677.117.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Benjamin Herrenschmidt wrote:

>  - I still think there's something wrong with dequeue_signal() being
> potentially called with a task different than current by signalfd, since
> __dequeue_signal() (among others) mucks around with current regardless.
> I'd love to just make signalfd's read() only do anything if current ==
> ctx->tsk and remove the task argument from dequeue_signal... that would
> fix it nicely too no ?

There's got to be a clean solution that does not limit signalfd, no? I 
have no time to look at it immediately, but I can look into it in the 
next few days, if someone else does not do it before...



- Davide


