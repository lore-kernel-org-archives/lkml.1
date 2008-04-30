Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbYD3V35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbYD3V35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbYD3V3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:29:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760681AbYD3V3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:29:42 -0400
Date: Wed, 30 Apr 2008 23:29:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] net: ipv6 build fix
Message-ID: <20080430212922.GA3031@elte.hu>
References: <20080430.013138.157977693.davem@davemloft.net> <20080430203839.GA19203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430203839.GA19203@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> this fix here is just a quick guess - i _suspect_ that 
> do_ipv6_getsockopt() will just DTRT and return -EINVAL but i havent 
> checked. It obviously solves the build issue.

i see now that it's a mismerge:

  http://marc.info/?l=linux-netdev&m=120956601217678&w=2

	Ingo
