Return-Path: <linux-kernel-owner+w=401wt.eu-S1761783AbZATOOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783AbZATOOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761401AbZATONm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:13:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18264 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761339AbZATONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:subject;
        b=Cs5ZBztRY+g6nsjryNPBBLpazNJ08c3Wv9WQN6HR5k9napbvkQ8I0GY43YMek6H/pX
         FVWQHYDEJouKsJKKGqEViCMYf3paMF8FcNBp/0IWKHMz3+6N9y1omCm5+r80mPozKiZ1
         mgeSq8ZS5/Nam4GywJ2jUgiLWwmtUtfzUV1xQ=
Message-Id: <4975dc11.0c07560a.7a93.ffff9782@mx.google.com>
User-Agent: quilt/0.46-1
Date: Tue, 20 Jan 2009 17:05:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: davem@davemloft.net, jchapman@katalix.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, devel@openvz.org, xemul@openvz.org
Subject: [PATCH 0/5] ppp,pppoe,pppol2tp -- introduce namespace functionality v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here is a series of patches in hope to bring
net-namespace functionality for PPP, PPPoE, PPPoL2TP
protocols.

I've tested plain PPP virtualization and it worked
for me. Quite may thanks to James Chapman who
was testing PPPoL2TP for me, thanks a lot again
James!

Please review and test if possible. I do really
appreciate _any_ kind of feedback. Thanks!

I didn't put Ack I got on previous series since it's
a bit new (though PPPoE didn't changed but anyway)

The patches are on top of net-2.6 commit

commit f4895b8bc83a22a36446c4aee277e1750fcc6a18
Author: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Date:   Mon Jan 19 13:19:30 2009 +0000

    wimax/i2400m: error paths that need to free an skb should use kfree_skb()

	Cyrill
-- 
