Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbYD3SOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbYD3SOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764037AbYD3SOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:14:35 -0400
Received: from mail.queued.net ([207.210.101.209]:4055 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764001AbYD3SOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:14:34 -0400
Date: Wed, 30 Apr 2008 14:17:41 -0400
From: Andres Salomon <dilinger@queued.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: ioremap ram check fix
Message-ID: <20080430141741.132b3a00@ephemeral>
In-Reply-To: <20080430181015.GB31726@elte.hu>
References: <20080430113024.43aa3935@ephemeral>
	<20080430181015.GB31726@elte.hu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 20:10:15 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andres Salomon <dilinger@queued.net> wrote:
> 
> > Hi Ingo,
> > 
> > bdd3cee2e4b7279457139058615ced6c2b41e7de (x86: ioremap(), extend check 
> > to all RAM pages) breaks OLPC's ioremap call.  The ioremap that OLPC 
> > uses is:
> 
> that breakage has been reported independently as well and the revert has 
> been pushed to Linus yesterday - it's not upstream yet. See this commit 
> in x86.git:
> 

Sure, either way.  FWIW, Vegard reported that the PAGE_MASK change made
the 150s delay disappear.



>  commit 1b8104a0ec138de829bb351f6597d534c7c134dc
>  Author: Ingo Molnar <mingo@elte.hu>
>  Date:   Tue Apr 29 12:04:51 2008 +0200
> 
>     revert: "x86: ioremap(), extend check to all RAM pages"
> 
>     Vegard Nossum reported a large (150 seconds) boot delay during bootup,
>     and bisected it to "x86: ioremap(), extend check to all RAM pages"
>     (commit bdd3cee2e4b). Revert this commit for now.
> 
>     Bisected-by: Vegard Nossum <vegard.nossum@gmail.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 	Ingo
