Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab0BHFM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:12:28 -0500
Received: from ozlabs.org ([203.10.76.45]:41424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab0BHFM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:12:27 -0500
Date: Mon, 8 Feb 2010 16:11:04 +1100
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
Message-ID: <20100208051104.GL32246@kryten>
References: <10125.1265451732@neuling.org>
 <18033.1265587672@neuling.org>
 <20100208140323.FB52.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208140323.FB52.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> Why do we need page size independent stack size? It seems to have
> compatibility breaking risk.

I don't think so. The current behaviour is clearly wrong, we dont need a
16x larger stack just because you went from a 4kB to a 64kB base page
size. The user application stack usage is the same in both cases.

Anton
