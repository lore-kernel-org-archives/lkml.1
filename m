Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYGVVkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYGVVkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYGVVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:39:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47246 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYGVVj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:39:58 -0400
Message-ID: <488653A9.50001@garzik.org>
Date: Tue, 22 Jul 2008 17:39:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHes] pull request: WAN
References: <m3ljzyc9e7.fsf@maximus.localdomain>
In-Reply-To: <m3ljzyc9e7.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Hi Jeff,
> 
> Please pull from:
> git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git hdlc
> 
> This is based on pure v2.6.26 and includes various WAN cleanups as
> well as LMC, Zilog (hostess_sv11 + sealevel = z85230) and Cosa drivers
> ported from syncppp to generic HDLC. I have no hardware for that so -
> untested.
> 
> This makes hdlc-ppp the only user of syncppp.
> 
> My plan is to replace hdlc-ppp and syncppp with the new hdlc-ppp, hope
> that's now ok with syncppp going.
> 
> The long-term plan is to also add generic PPP interface so users can
> do PPP auth, compression and what not. 2.6.30+ maybe.
> 
> I have tried to test-merge your upstream-next branch and it causes
> conflicts in drivers/net/wan/pc300_drv.c (a trivial one) and
> net/netfilter/nf_conntrack_proto_tcp.c (some pre-2.6.26 thing I
> guess).
> 
> The first commits in my tree (after v2.6.26) are already in your tree,
> you've got them by mail. It seems that git knows that.

Anything in upstream-next went upstream, and so we need to apply this on 
top of the current Linus upstream (torvalds/linux-2.6.git) at the very 
least.

Would you mind doing that, please?

Also, git pulls are great, but it would be helpful if you supply a 
git-shortlog summary of the changes, and the patch (>400k will only go 
to me, list will ignore).

	Jeff



