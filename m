Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZEKM1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZEKM1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZEKM1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:27:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbZEKM1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:27:33 -0400
Date: Mon, 11 May 2009 14:27:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] memcg fix stale swap cache account leak v6
Message-ID: <20090511122711.GF13954@elte.hu>
References: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com> <20090508140910.bb07f5c6.kamezawa.hiroyu@jp.fujitsu.com> <20090508113820.GL11596@elte.hu> <a369eb83999c47faac2bc894c2f43a9d.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a369eb83999c47faac2bc894c2f43a9d.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > Isnt the right solution to have a better LRU that is aware of 
> > this, instead of polling around in the hope of cleaning up stale 
> > entries?
>
> I tried to modify LRU in the last month but I found it's 
> difficult.

But your patch makes such a correct solution even more difficult to 
achieve, so in that sense it might be a step backwards, right?

	Ingo
