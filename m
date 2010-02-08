Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab0BHFW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:22:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35451 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0BHFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:22:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] Restrict stack space reservation to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Michael Neuling <mikey@neuling.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org, miltonm@bga.com, aeb@cwi.nl
In-Reply-To: <20100208051104.GL32246@kryten>
References: <20100208140323.FB52.A69D9226@jp.fujitsu.com> <20100208051104.GL32246@kryten>
Message-Id: <20100208141716.FB55.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  8 Feb 2010 14:22:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> Hi,
> 
> > Why do we need page size independent stack size? It seems to have
> > compatibility breaking risk.
> 
> I don't think so. The current behaviour is clearly wrong, we dont need a
> 16x larger stack just because you went from a 4kB to a 64kB base page
> size. The user application stack usage is the same in both cases.

I didn't discuss which behavior is better. Michael said he want to apply
his patch to 2.6.32 & 2.6.33. stable tree never accept the breaking
compatibility patch.

Your answer doesn't explain why can't we wait it until next merge window.


btw, personally, I like page size indepent stack size. but I'm not sure
why making stack size independency is related to bug fix.



