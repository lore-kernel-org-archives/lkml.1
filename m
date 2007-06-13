Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXFML3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXFML3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbXFML3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:29:01 -0400
Received: from stinky.trash.net ([213.144.137.162]:61224 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbXFML3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:29:00 -0400
Message-ID: <466FD439.2040807@trash.net>
Date: Wed, 13 Jun 2007 13:25:45 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cannot set IP for ethernet
References: <200706121441.13561.oliver@neukum.org> <200706131039.32011.oliver@neukum.org> <466FD17A.8040900@trash.net> <200706131321.30451.oliver@neukum.org>
In-Reply-To: <200706131321.30451.oliver@neukum.org>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 13. Juni 2007 schrieb Patrick McHardy:
>>>>
>>>>This can happen if the initial inetdev allocation when the netdevice is
>>>>registered fails. I think it would make sense to try to allocate again
>>>>when adding addresses in that case, otherwise there is no way of
>>>>recovery other than unregistering and registering the device again.
>>>
>>>
>>>With your patch the problem has gone away. Is there a way to especially
>>>stress the system in that regard?
>>
>>
>>Its a failed allocation at NETDEV_REGISTER time. I guess you could
>>keep unloading + reloading the driver module to try to reproduce it.
> 
> 
> If that is the cause, why doesn't it strike from the very beginning? How
> come it fails after some time?


It might also be a failed in_ifaddr allocation. In that case my patch
shouldn't help though.
