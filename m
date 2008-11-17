Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYKQTs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYKQTs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKQTsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:48:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbYKQTsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:48:16 -0500
Date: Mon, 17 Nov 2008 11:47:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117.113158.200497613.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811171134480.18283@nehalem.linux-foundation.org>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <20081117.113158.200497613.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, David Miller wrote:
> 
> The scheduler has accounted for at least %10 of the tbench
> regressions at this point, what are you talking about?

I'm wondering if you're not looking at totally different issues.

For example, if I recall correctly, David had a big hit on the hrtimers. 
And I wonder if perhaps Ingo's numbers are without hrtimers or something? 

The other possibility is that it's just a sparc suckiness issue, that 
simply doesn't show up on x86. 

		Linus
