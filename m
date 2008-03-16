Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYCPQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYCPQZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 12:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYCPQZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 12:25:05 -0400
Received: from mail.reagi.com ([195.60.188.80]:39239 "EHLO mail.reagi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbYCPQYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 12:24:49 -0400
Message-ID: <47DD49C6.8040400@oxeva.fr>
Date: Sun, 16 Mar 2008 17:24:38 +0100
From: Gabriel Barazer <gabriel@oxeva.fr>
Organization: OXEVA
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6.24.3][net] bug: TCP 3rd handshake abnormal timeouts
References: <47DB28E9.4050309@oxeva.fr> <20080315065739.GL8953@1wt.eu> <20080315065849.GA11817@1wt.eu> <47DB8D1C.7020006@oxeva.fr> <20080315085527.GA6239@1wt.eu>
In-Reply-To: <20080315085527.GA6239@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 03/15/2008 9:55:27 AM +0100, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Mar 15, 2008 at 09:47:24AM +0100, Gabriel Barazer wrote:
> 
> Feel free to repost the whole issue overthere (along with your new tests)
> if you don't get useful replies in a few days.
> 
>> By the way thanks for replying. It's hard to explain and describe a 
>> problem when you know people will ask you hundreds of questions related 
>> to application-level problems, or not reply because web/mysql problems 
>> are so common and generally not related to any kernel issue.
> 
> What caught my attention was the usual "3s delay", which is purely TCP
> and application-independant.
> 
> 
>>> Also, you say you have netfilter with conntrack. Is this on the client ?
>>> If so, you should try disabling it to rule out any possible bug in the
>>> connection tracking.
>> I have the conntrack  on both the client and server, and unfortunately 
>> can't disable it now on the client (I use it only for the REDIRECT 
>> target on a precise destination address and port, not MySQL related), 
>> however I will test today and disable it on the server, after I get some 
>> sleep (although I think the issue is on the client).
> 
> I'm sure it's a client issue too, that's why it would be reasonable to
> be able to try without conntrack. Can't you use a TCP proxy instead of
> REDIRECT ? Also, you said that you also noticed the same behaviour in
> other environments, maybe there you can disable conntrack ?

I was able to reproduce the bug multiple times without conntrack nor 
netfilter on the client and the server(I recompiled the kernel disabling 
the entire netfilter subsystem). The 3-second problem still occurs so we 
can completely rule out contrack-related bugs.

What can we do and test next?

Gabriel
