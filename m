Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZLLKtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZLLKtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZLLKtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:49:16 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:54453 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZLLKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:49:16 -0500
Message-ID: <4B237528.8020708@gmail.com>
Date: Sat, 12 Dec 2009 11:49:12 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20091211.181712.211179737.davem@davemloft.net> <4B236C18.4050007@gmail.com>
In-Reply-To: <4B236C18.4050007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 12 Dec 2009 11:49:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/12/2009 11:10, William Allen Simpson a écrit :
> David Miller wrote:
>> David S. Miller (4):
>>       Merge branch 'master' of
>> git://git.kernel.org/.../linville/wireless-next-2.6
>>       tcp: Remove runtime check that can never be true.
> 
> This is a poor patch that was never sent to the netdev list for review. 
> Copies to
> and from user space should always check for buffer overruns.  A better
> patch was
> submitted (attached) some time ago.
> 
> Miller's patch has 2 flaws:
> 
>  1) It accidentally removed a comment line that describes the purpose of
> the
> following memcpy(), paralleling language in the internet-draft.
> 
>  2) It fails to test for buffer overruns.  The existing code has an
> accurate test,
> that compiles (to no code) correctly with current gcc.  But it produces
> a warning
> in some (fairly old) gcc versions.
> 
> Instead, the better patch uses the Kernel defined BUILD_BUG_ON().  Please
> substitute the better patch in the main tree.
> 
> 
>>       Merge branch 'master' of
>> git://git.kernel.org/.../linville/wireless-2.6
>>       Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
>>

William, as I already said, you wont solve your problem with David
alerting whole earth, Linus, God, whoever, because we dont care,
we have our own problems.

This drama is really ridiculous, could we go forward, correct bugs,
add documentation, and so on ?

If you really want this BUILD_BUG_ON() (because some dev could
introduce a bug changing TCP_COOKIE_PAIR_SIZE or TCP_MSS_DEFAULT (???)
in the future, without David or other network dev noticing this),
please submit a _normal_ patch against net-2.6 and through David Miller,
the official network maintainer, your best friend for network patches.

