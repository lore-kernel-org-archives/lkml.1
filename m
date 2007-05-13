Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbXEMQti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbXEMQti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbXEMQta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:49:30 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2564 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287AbXEMQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:49:29 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 13 May 2007 09:49:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: undefined reference to `__clear_user' (was: Re: [patch 2/13]
 signal/timer/event fds v10 - signalfd core ...)
In-Reply-To: <Pine.LNX.4.64.0705131222410.2271@anakin>
Message-ID: <Pine.LNX.4.64.0705130945410.2979@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0704021555430.26489@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0705131222410.2271@anakin>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Geert Uytterhoeven wrote:

> I only noticed because m68k doesn't have __clear_user(), as this routine
> was never needed by generic code before your change.

As I told to Al, I could use clear_user in there, but IMO it'd be better 
to align m68k to the standard Linux user access rule (double-underscore 
and not double-underscore version).


- Davide


