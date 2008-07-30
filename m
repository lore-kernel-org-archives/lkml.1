Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYG3Tpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYG3Tpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYG3TpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:45:22 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13290 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYG3TpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:45:19 -0400
Date: Wed, 30 Jul 2008 21:45:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
Message-ID: <20080730194516.GO20055@kernel.dk>
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30 2008, Miklos Szeredi wrote:
> > On Wed, 30 Jul 2008, Jens Axboe wrote:
> > > You snipped the part where Linus objected to dismissing the async
> > > nature, I fully agree with that part.
> 
> And also note in what Nick said in the referenced mail: it would be
> nice if someone actually _cared_ about the async nature.  The fact
> that it has been broken from the start, and nobody noticed is a strong
> hint that currently there isn't anybody who does.

That's largely due to the (still) lack of direct splice users. It's a
clear part of the design and benefit of using splice. I very much care
about this, and as soon as there are available cycles for this, I'll get
it into better shape in this respect. Taking a step backwards is not the
right way forward, imho.

> Maybe fuse will be the first one to actually care, and then I'll
> bother with putting a lot of effort into it.  But until someone cares,
> nobody will bother, and that's how it should be.  That's very much in
> line with the evoultionary nature of kernel developments: unused
> features will just get broken and eventually removed.

People always say then, and the end result is it never gets done. Not to
point the finger at Nick, but removing the steal part of the splice
design was something I objected to a lot. Yet it was acked on the
premise that it would eventually get resubmitted in a fixed manner, but
were are not further along that path.

-- 
Jens Axboe

