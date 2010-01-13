Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166Ab0AMIya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0AMIya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012Ab0AMIy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:54:28 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33006 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0AMIy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:54:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=i18yb4XwaHCmnf6NQQ9ea3w3pHfU422Zan5n2V6+KaiL1NRPfYRNBzf4DuansojWL8
         +qLFu2OE5KJ50jabI6jVykGi7zLhsLceNCShh3Zm6QG7s3kK4TeYvdwXGWlw7gG66Z5S
         2TjmdfmEG4yWTG/TleFRuxfLlGNccnaOFhZeA=
Date: Wed, 13 Jan 2010 08:54:18 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Octavian Purdila <opurdila@ixiacom.com>
Subject: Re: linux-next: Tree for January 8 (net/ip.h, BUG=n)
Message-ID: <20100113085418.GB6053@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113073540.GA30577@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian added to cc.

Jarek P.

On 13-01-2010 08:35, Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Fri, 8 Jan 2010 16:42:32 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20100107:
>>
>> When CONFIG_BUG=n, CONFIG_GENERIC_BUG=n:
>>
>> include/net/ip.h:341: error: implicit declaration of function '__WARN'
>>
>> This affects:
>> make[3]: *** [security/selinux/hooks.o] Error 1
>> make[3]: *** [fs/ceph/messenger.o] Error 1
>> make[3]: *** [net/core/sock.o] Error 1
>> make[4]: *** [drivers/net/benet/be_main.o] Error 1
> 
> FYI, this new build bug is now upstream and triggers in -tip testing as well.
> 
> 	Ingo
