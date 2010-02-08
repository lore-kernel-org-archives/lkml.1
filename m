Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab0BHFcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:32:45 -0500
Received: from ozlabs.org ([203.10.76.45]:40076 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0BHFco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:32:44 -0500
Date: Mon, 8 Feb 2010 16:31:25 +1100
From: Anton Blanchard <anton@samba.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Neuling <mikey@neuling.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org, miltonm@bga.com, aeb@cwi.nl
Subject: Re: [PATCH] Restrict stack space reservation to rlimit
Message-ID: <20100208053125.GN32246@kryten>
References: <20100208140323.FB52.A69D9226@jp.fujitsu.com>
 <20100208051104.GL32246@kryten>
 <20100208141716.FB55.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208141716.FB55.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> I didn't discuss which behavior is better. Michael said he want to apply
> his patch to 2.6.32 & 2.6.33. stable tree never accept the breaking
> compatibility patch.
> 
> Your answer doesn't explain why can't we wait it until next merge window.
> 
> 
> btw, personally, I like page size indepent stack size. but I'm not sure
> why making stack size independency is related to bug fix.

OK sorry, I misunderstood your initial mail. I agree fixing the bit that
regressed in 2.6.32 is the most important thing. The difference in page size is
clearly wrong but since it isn't a regression we could probably live with it
until 2.6.34

Anton
