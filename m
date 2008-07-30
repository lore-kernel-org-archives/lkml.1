Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYG3SpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYG3SpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYG3Sow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:44:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54347 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbYG3Sov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:44:51 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 30 Jul 2008 20:32:14 +0200)
Subject: Re: [patch v3] splice: fix race with page invalidation
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0807300958390.3334@nehalem.linux-foundation.org> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk> <E1KOGT8-0000rd-0Z@pomaz-ex.szeredi.hu>
Message-Id: <E1KOGeO-0000yi-EM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 20:43:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 30 Jul 2008, Jens Axboe wrote:
> > You snipped the part where Linus objected to dismissing the async
> > nature, I fully agree with that part.

And also note in what Nick said in the referenced mail: it would be
nice if someone actually _cared_ about the async nature.  The fact
that it has been broken from the start, and nobody noticed is a strong
hint that currently there isn't anybody who does.

Maybe fuse will be the first one to actually care, and then I'll
bother with putting a lot of effort into it.  But until someone cares,
nobody will bother, and that's how it should be.  That's very much in
line with the evoultionary nature of kernel developments: unused
features will just get broken and eventually removed.

Miklos
