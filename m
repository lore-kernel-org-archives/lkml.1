Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYISXbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYISXbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYISXb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:31:29 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:49237 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYISXb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:31:28 -0400
Date: Fri, 19 Sep 2008 16:31:20 -0700 (PDT)
From: Steven Noonan <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Ingo Molnar <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5,
 rc6, probably others)
In-Reply-To: <20080919182322.GB7027@tesla>
Message-ID: <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
References: <20080918220102.GE7408@tesla> <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com> <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com> <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com>
 <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com> <20080919030125.GG7408@tesla> <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com> <20080919142801.GA5816@senthil-lnx.users.atheros.com> <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
 <20080919175824.GA5626@senthil-lnx.users.atheros.com> <20080919182322.GB7027@tesla>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Sep 2008, Luis R. Rodriguez wrote:
> Thanks for the patch Senthil. He is on Linus' v2.6.27-rc, you are on
> wireless-testing so I've ported it (no changes, it just applies cleanly
> now). This is also untested by me:

I'm seeing the same latency issue I reported originally with the latest 
-tip kernel and WITHOUT irqpoll.

Apparently there's something else to this...

- Steven
