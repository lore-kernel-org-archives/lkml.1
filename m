Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYG3VQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYG3VQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYG3VQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:16:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49280 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbYG3VQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:16:35 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LFD.1.10.0807301349020.3334@nehalem.linux-foundation.org>
	(message from Linus Torvalds on Wed, 30 Jul 2008 13:51:36 -0700 (PDT))
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
 <20080730194516.GO20055@kernel.dk> <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301310130.3334@nehalem.linux-foundation.org> <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301349020.3334@nehalem.linux-foundation.org>
Message-Id: <E1KOJ1s-0002a5-Im@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 23:16:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> > 
> > It _is_ a bug fix.
> 
> No it's not.
> 
> It's still papering over a totally unrelated bug. It's not a "fix", it's a 
> "paper-over". It doesn't matter if _behaviour_ changes.
> 
> Can you really not see the difference?
> 
> Afaik, everybody pretty much agreed what the real fix should be (don't 
> mark the page not up-to-date, just remove it from the radix tree)

Huh?  I did exactly that, and that patch got NAK'ed by you and Nick:

http://lkml.org/lkml/2008/6/25/230
http://lkml.org/lkml/2008/7/7/21

Confused.

> I'm not seeing why you continue to push the patch that ALREADY GOT
> NAK'ed.

And later ACK'ed by Nick.

There's everything here but agreement about a solution :)

Miklos
