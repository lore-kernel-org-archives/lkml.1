Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbXJMRuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbXJMRuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbXJMRuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:50:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57657 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753714AbXJMRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:50:07 -0400
Date: Sat, 13 Oct 2007 19:50:36 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.21 review 12/35] TCP: Fix TCP handling of SACK in
	bidirectional flows.
Message-ID: <20071013175036.GD4211@stusta.de>
References: <20071013142822.%N@1wt.eu> <20071013143452.%N@1wt.eu> <Pine.LNX.4.64.0710132007430.27718@kivilampi-30.cs.helsinki.fi> <20071013172214.GA18155@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071013172214.GA18155@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 07:22:14PM +0200, Willy Tarreau wrote:
>...
> Thanks for your help, I really appreciate it. In fact, I've reviewed them
> four, but two of them did not apply and the code looked somewhat different,
> so I considered them irrelevant to 2.6.20. I didn't understand that they
> were all related, so maybe I checked them in a wrong order.
> 
> I'll recheck all that in the right sequence and will merge them four, or
> get back to you if something still puzzles me.

I discussed this issue with Ilpo just yesterday regarding 2.6.16, and 
the result of our discussion was that I reverted it.

TCP being in some situations a bit more conservative than it should be 
isn't a big issue and not worth backporting with a risk of introducing
a regression.

I'd recommend you simply drop the two patches for 2.6.20.

> Thanks!
> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

