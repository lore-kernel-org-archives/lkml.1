Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYG3Vqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYG3Vqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYG3VqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:46:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46314 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYG3VqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:46:19 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LFD.1.10.0807301418270.3277@nehalem.linux-foundation.org>
	(message from Linus Torvalds on Wed, 30 Jul 2008 14:22:13 -0700 (PDT))
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
 <20080730194516.GO20055@kernel.dk> <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301310130.3334@nehalem.linux-foundation.org> <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301349020.3334@nehalem.linux-foundation.org>
 <E1KOJ1s-0002a5-Im@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807301418270.3277@nehalem.linux-foundation.org>
Message-Id: <E1KOJUk-0002vA-8w@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 23:46:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Linus Torvalds wrote:
> On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> > 
> > Huh?  I did exactly that, and that patch got NAK'ed by you and Nick:
> 
> Umm. That was during the late -rc sequence (what, -rc8?) where I wanted a 
> minimal "let's fix it". Not that anybody then apparently cared, which is 
> probably just as well.
> 
> Then you did NOTHING AT ALL about it, now the merge window is over, and 
> you complain again, with what looks like basically the same patch that was 
> already rejected earlier.
> 
> Hellooo..

You are being unfair: after having talked it over with Nick I
resubmitted this patch (not the same), which was added to -mm and
nobody complained then. Then it got thrown out of -mm during the merge
window because of a conflict, and then now I got around to
resubmitting it again.

But you're the boss, if you don't like it it won't go in.  I'll have a
look at the "don't clear PG_uptodate" solution again and see if we can
get an agreement there.

Miklos
