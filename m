Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXG1PtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXG1PtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXG1Psv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:48:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:46656 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbXG1Psu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HiyMmPyLY0ovcjbyLItUmGlhpJm0V3cm4GDVzbKr+XYsPs92Nq9wLZfPHw9BEPfEQi40J5nV6xnevqDJcvJKh/O/04AyCwICL3nXvWlPW13TqbaT2FQT8HtoFsyux0MhJJRMfAPbO2ZkjOibpGeY85HBssU0NaaHifEVL+BpgTE=
Message-ID: <46AB646D.8020104@googlemail.com>
Date: Sat, 28 Jul 2007 17:44:45 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jason.wessel@windriver.com, amitkale@linsyssoft.com
Subject: NETPOLL=y , NETDEVICES=n compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this compile error with a randconfig ( http://194.231.229.228/MM/randconfig-auto-82.broken.netpoll.c ).

...

net/core/netpoll.c: In function 'netpoll_poll':
net/core/netpoll.c:155: error: 'struct net_device' has no member named 'poll_controller'
net/core/netpoll.c:159: error: 'struct net_device' has no member named 'poll_controller'
net/core/netpoll.c: In function 'netpoll_setup':
net/core/netpoll.c:670: error: 'struct net_device' has no member named 'poll_controller'
make[2]: *** [net/core/netpoll.o] Error 1
make[1]: *** [net/core] Error 2
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....

...


I think is because KGDBOE selects just NETPOLL.


Regards,

Gabriel
