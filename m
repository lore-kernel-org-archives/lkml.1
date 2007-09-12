Return-Path: <linux-kernel-owner+w=401wt.eu-S968155AbXILMk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968155AbXILMk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966125AbXILMkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:40:10 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:37276
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966555AbXILMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:40:07 -0400
Date: Wed, 12 Sep 2007 05:34:11 -0700 (PDT)
Message-Id: <20070912.053411.21914920.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, satyam@infradead.org, flo@rfc822.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: David Miller <davem@davemloft.net>
In-Reply-To: <1189091995.28781.99.camel@johannes.berg>
References: <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
	<20070906082301.GB21929@gondor.apana.org.au>
	<1189091995.28781.99.camel@johannes.berg>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 06 Sep 2007 17:19:55 +0200

> 
> Oh btw. Can we stick a might_sleep() into dev_close() *before* the test
> whether the device is up? That way, we'd have seen the bug, but
> apparently nobody before Florian ever did a 'ip link set wmaster0 down'
> while the other interfaces were still open.

I've added this to net-2.6.24
