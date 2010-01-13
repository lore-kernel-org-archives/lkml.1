Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984Ab0AMHgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0AMHgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 02:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954Ab0AMHgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 02:36:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab0AMHgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 02:36:00 -0500
Date: Wed, 13 Jan 2010 08:35:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: Tree for January 8 (net/ip.h, BUG=n)
Message-ID: <20100113073540.GA30577@elte.hu>
References: <20100108164232.d3e1a164.sfr@canb.auug.org.au>
 <20100108092505.4f4e1ac3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108092505.4f4e1ac3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 8 Jan 2010 16:42:32 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100107:
> 
> 
> When CONFIG_BUG=n, CONFIG_GENERIC_BUG=n:
> 
> include/net/ip.h:341: error: implicit declaration of function '__WARN'
> 
> This affects:
> make[3]: *** [security/selinux/hooks.o] Error 1
> make[3]: *** [fs/ceph/messenger.o] Error 1
> make[3]: *** [net/core/sock.o] Error 1
> make[4]: *** [drivers/net/benet/be_main.o] Error 1

FYI, this new build bug is now upstream and triggers in -tip testing as well.

	Ingo
