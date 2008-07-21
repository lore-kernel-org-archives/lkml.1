Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYGUBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYGUBIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYGUBIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:08:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238AbYGUBIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:08:07 -0400
Date: Sun, 20 Jul 2008 18:07:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [GIT]: Networking
In-Reply-To: <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807201804410.31863@woody.linux-foundation.org>
References: <20080720.104411.81744468.davem@davemloft.net> <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This warning also seems to be new:

	net/ipv6/addrconf.c: In function ¡addrconf_add_linklocal¢:
	net/ipv6/addrconf.c:2318: warning: unused variable ¡net¢

and looking at the code it's apparently because I'm not an optimistic 
enough dad.

But hey, if you had three pre-teenage girls, you might not be all that 
optimistic either. So I think that's reasonable.

Problem seems to have been introduced by 53b7997f ("ipv6 netns: Make 
several "global" sysctl variables namespace aware")

		Linus
