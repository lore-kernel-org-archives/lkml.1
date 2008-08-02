Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYHBT4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYHBT4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYHBT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:56:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbYHBT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:56:29 -0400
Date: Sat, 2 Aug 2008 12:56:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Abdel Benamrouche <draconux@gmail.com>, stable@kernel.org,
       jens.axboe@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1]  fs/partition/check.c: fix return value
 warning
In-Reply-To: <200808022202.48079.oliver.pntr@gmail.com>
Message-ID: <alpine.LFD.1.10.0808021254190.3874@nehalem.linux-foundation.org>
References: <200808022202.48079.oliver.pntr@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Aug 2008, Oliver Pinter wrote:
>
> Subject: [PATCH] fs/partition/check.c: fix return value warning
> 
> [ Upstream commit d805dda412346225a50af2d399d958a4bc676c38 ]

Why are these being submitted for stable kernels?

Oliver - stable kernels should _not_ get trivial fixes that don't actually 
have any problems associated with them. 

Every patch in a stable kernel has a downside. It had better have a big 
upside too.  These don't.

Please don't just send patches to the stable team because they "look 
fine". They should be real bugs, with real consequences. And no, a 
compiler warning is not a real consequence.

		Linus
