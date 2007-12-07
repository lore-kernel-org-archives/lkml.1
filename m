Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXLGDXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXLGDXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXLGDWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:22:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48410
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbXLGDWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:22:50 -0500
Date: Thu, 06 Dec 2007 19:22:49 -0800 (PST)
Message-Id: <20071206.192249.193354742.davem@davemloft.net>
To: ricknu-0@student.ltu.se
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [Patch] net/xfrm/xfrm_policy.c: Some small improvements
From: David Miller <davem@davemloft.net>
In-Reply-To: <4758093A.7010608@student.ltu.se>
References: <20071206110123.GB2469@hacking>
	<20071206.031434.179419183.davem@davemloft.net>
	<4758093A.7010608@student.ltu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Knutsson <ricknu-0@student.ltu.se>
Date: Thu, 06 Dec 2007 15:37:46 +0100

> David Miller wrote:
> > But this time I'll just let you know up front that I
> > don't see much value in this patch.  It is not a clear
> > improvement to replace int's with bool's in my mind and
> > the other changes are just whitespace changes.
> >   
> Is it not an improvement to distinct booleans from actual values? Do you 
> use integers for ASCII characters too? It can also avoid some potential 
> bugs like the 'if (i == TRUE)'...
> What is wrong with 'size_t' (since it is unsigned, compared to (some) 
> 'int')?

When you say "int found;" is there any doubt in your mind that
this integer is going to hold a 1 or a 0 depending upon whether
we "found" something?

That's the problem I have with these kinds of patches, they do
not increase clarity, it's just pure mindless edits.

In new code, fine, use booleans if you want.

I would even accept that it helps to change to boolean for
arguments to functions that are global in scope.

But not for function local variables in cases like this.
