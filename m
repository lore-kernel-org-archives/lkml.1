Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXCEVjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXCEVjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbXCEVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:39:47 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:44334 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbXCEVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:39:46 -0500
Message-ID: <45EC8DF9.6060407@cosmosbay.com>
Date: Mon, 05 Mar 2007 22:39:05 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch - v2/resend] epoll ready set loops diet ...
References: <Pine.LNX.4.64.0703051308060.4907@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703051308060.4907@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 05 Mar 2007 22:39:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> ChangeLog:
> 
> v2) In v1, I was trying to avoid to get the spinlock twice WRT yesterday 
>     patch, but it turns out I can't since the ready list will be travelling 
>     through a path w/out the ep->sem held. Oh well...
> 
> 

What about the epitem->revents that we agreed to suppress ?

Me confused...
