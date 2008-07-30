Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYG3Uzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYG3Uzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYG3UzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:55:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYG3UzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:55:24 -0400
Date: Wed, 30 Jul 2008 13:51:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0807301349020.3334@nehalem.linux-foundation.org>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
 <20080730194516.GO20055@kernel.dk> <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301310130.3334@nehalem.linux-foundation.org> <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> 
> It _is_ a bug fix.

No it's not.

It's still papering over a totally unrelated bug. It's not a "fix", it's a 
"paper-over". It doesn't matter if _behaviour_ changes.

Can you really not see the difference?

Afaik, everybody pretty much agreed what the real fix should be (don't 
mark the page not up-to-date, just remove it from the radix tree), I'm not 
seeing why you continue to push the patch that ALREADY GOT NAK'ed.

			Linus
