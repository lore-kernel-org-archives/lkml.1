Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZGAQXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZGAQXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZGAQWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:22:51 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:49672 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbZGAQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:22:49 -0400
Date: Thu, 2 Jul 2009 00:22:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Paul Martin <pm@debian.org>
Subject: Re: [Bug #13627] Tunnel device ignores TCP/UDP traffic
Message-ID: <20090701162248.GB5338@gondor.apana.org.au>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.AtD.NJASKB@chimera> <b6a2187b0907010734w7e7a5bbfm271f44e57e12d1b4@mail.gmail.com> <20090701151344.GA4372@gondor.apana.org.au> <b6a2187b0907010914x1c68e09k24bc9378e9c0519c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0907010914x1c68e09k24bc9378e9c0519c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 12:14:37AM +0800, Jeff Chua wrote:
> > work? Does reverting d55d87fdff8252d0e2f7c28c2d443aee17e9d70f help?
> 
> My Linux git already has these two commits, and I tested it with vpnc
> (0.5.3) and it connected, but can't ping or ssh to remote. It was
> working prior to 2.6.30.
> 
> Tested reverting d55d87fdff8252d0e2f7c28c2d443aee17e9d70f, but still
> no good. Also reverted 71f9dacd2e4d233029e9e956ca3f79531f411827, still
> no good.

OK then your problem is a completely different issue.  Please
strace vpnc and see what it's doing.  You should also take a
tcpdump on the tun interface to go with the strace.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
