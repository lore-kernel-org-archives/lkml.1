Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYGWVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYGWVb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYGWVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:31:17 -0400
Received: from khc.piap.pl ([195.187.100.11]:57024 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbYGWVbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:31:16 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHes] pull request: WAN
References: <m3ljzyc9e7.fsf@maximus.localdomain> <488653A9.50001@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 23 Jul 2008 23:31:13 +0200
In-Reply-To: <488653A9.50001@garzik.org> (Jeff Garzik's message of "Tue\, 22 Jul 2008 17\:39\:53 -0400")
Message-ID: <m3hcags2xq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Anything in upstream-next went upstream, and so we need to apply this
> on top of the current Linus upstream (torvalds/linux-2.6.git) at the
> very least.
>
> Would you mind doing that, please?

No problem, though I guess David would hate us both if I do that,
so I actually rebased on top of your "upstream" instead, is it ok?

It's now at:

git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git for-jeff

> Also, git pulls are great, but it would be helpful if you supply a
> git-shortlog summary of the changes, and the patch (>400k will only go
> to me, list will ignore).

Sure,

Krzysztof Ha³asa (15):
      WAN: cosmetic changes to generic HDLC
      Remove bogus dosyncppp variable from synclink drivers.
      Remove bogus variables from syncppp.[ch]
      Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
      wanmain.c doesn't need syncppp.h
      WAN: Remove unneeded "#include <net/syncppp.h>"
      WAN: Remove dead code from PC300 driver, part #1
      WAN: Remove dead code from PC300 driver, part #2
      WAN: Convert PC300 driver to use normal u8/u16/u32 types
      WAN: farsync driver no longer uses syncppp.c directly
      WAN: Port COSA driver to generic HDLC.
      WAN: Convert Zilog-based drivers to generic HDLC
      WAN: Port LMC driver to generic HDLC
      WAN: don't mention syncppp in z8530 DocBook.
      WAN: Use u32 type instead of u_int32_t in LMC driver.

The combined patch follows.
-- 
Krzysztof Halasa
