Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbZLLKGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbZLLKGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761303AbZLLKGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:06:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbZLLKGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:06:17 -0500
Date: Sat, 12 Dec 2009 02:06:14 -0800 (PST)
From: lists@nerdbynature.de
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
In-Reply-To: <4B2360BF.5000102@gmail.com>
Message-ID: <alpine.DEB.2.01.0912120203020.2915@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912112335440.2915@bogon.housecafe.de> <20091212.010340.227842186.davem@davemloft.net> <4B2360BF.5000102@gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/1HCxvCjhngPhWwJMtj/aqM0uQrDE3S5Z8ix+
 h6poi8Ug49l338Alfyo0E9o5so3fRrO6v4s5G6w8xII+JGJ7lk
 IHQG3R2zZ6pc7r3TSERNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 at 10:22, Eric Dumazet wrote:
> > Yeah I started seeing this on one of my machines too, the
> > assertion is:
> > 
> > 	WARN_ON(newsk->sk_state == TCP_SYN_RECV);
> > 
> > I wonder if some of the refactorings we did to allow per-route
> > SACK/DSACK/etc. controls messed some sequence of state changes
> > on TCP sockets.  But I can't find anything obvious in those
> > commits.
> 
> Could it be about syncookies patches ?
> tcp_create_openreq_child() changes ?

Hm, I'd like to reproduce this thing and just ran "siege" against the 
proxy, spawning > 10k connections (simliar to when the warnings appeared) 
but I can't trigger the message any more. I'm tempted to bisect, but this 
is no fun when I cannot reproduce the messages :-\

Christian.
-- 
BOFH excuse #140:

LBNC (luser brain not connected)
