Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbYG3UG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbYG3UG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYG3UGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:06:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48459 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYG3UGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:06:49 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20080730194516.GO20055@kernel.dk> (message from Jens Axboe on
	Wed, 30 Jul 2008 21:45:16 +0200)
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu> <20080730194516.GO20055@kernel.dk>
Message-Id: <E1KOHvq-0001oX-OW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 22:05:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Jens Axboe wrote:
> On Wed, Jul 30 2008, Miklos Szeredi wrote:
> > > On Wed, 30 Jul 2008, Jens Axboe wrote:
> > > > You snipped the part where Linus objected to dismissing the async
> > > > nature, I fully agree with that part.
> > 
> > And also note in what Nick said in the referenced mail: it would be
> > nice if someone actually _cared_ about the async nature.  The fact
> > that it has been broken from the start, and nobody noticed is a strong
> > hint that currently there isn't anybody who does.
> 
> That's largely due to the (still) lack of direct splice users. It's a
> clear part of the design and benefit of using splice. I very much care
> about this, and as soon as there are available cycles for this, I'll get
> it into better shape in this respect. Taking a step backwards is not the
> right way forward, imho.

So what is?  The only way forward is to put those cycles into it,
which nobody seems to have available.

Take this patch as a bugfix.  It's not in any way showing the way
forward: as soon as you have the time, you can revert it and start
from the current state.

Hmm?

Miklos
