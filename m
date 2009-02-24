Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZBXNoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZBXNoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZBXNoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:44:23 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:49881 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZBXNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:44:22 -0500
Message-ID: <49A3F974.5030801@free.fr>
Date: Tue, 24 Feb 2009 14:43:16 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: !CONFIG_NET_NS build error, net/core/net_namespace.c
References: <1235480427.5965.22.camel@marge.simson.net>
In-Reply-To: <1235480427.5965.22.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
>   CC      net/core/net_namespace.o
> net/core/net_namespace.c: In function ‘net_ns_init’:
> net/core/net_namespace.c:223: error: implicit declaration of function ‘net_alloc_generic’
> net/core/net_namespace.c:223: warning: assignment makes pointer from integer without a cast
> make[2]: *** [net/core/net_namespace.o] Error 1
> make[1]: *** [net/core] Error 2
> make: *** [net] Error 2
>
>   
Thanks, this has been fixed with commit 
ebe47d47b7b7fed72dabcce4717da727b4e2367d
Sorry for the inconvenience.

  -- Daniel
