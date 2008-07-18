Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYGRJMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYGRJMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYGRJMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:12:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbYGRJMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:12:36 -0400
Date: Fri, 18 Jul 2008 11:11:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cl@linux-foundation.org,
       davem@davemloft.net, johnpol@2ka.mipt.ru
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080718091146.GQ6875@elte.hu>
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> >   Object 0xf658ae70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> 
> It's bit unfortunate that we don't see full dump of the corruption 
> here because SLUB limits the output to 128 bytes. Ingo, you might want 
> to try this patch so that we can see all of it:

ok, applied this as a debug special to tip/out-of-tree - future 
incidents should have the full object dump.

would makes sense for upstream too i think, or increase the limit to 4K 
or so. (which is still fair to be dumped into a syslog)

	Ingo
