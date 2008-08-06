Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYHFSKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYHFSKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYHFSKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:10:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:45518 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYHFSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iOb/QaiNGHU72AX0615q4qKj6QA2WNGRQI2VxQjmNbEyKFA2oAgAcVx/hAO7+RsIov
         biCW96hxURBZh84oVrAuFrGpcdi7/+YJMaQ7Y1VYViD5rxmQ2cw6NyHE1SK4cKZJ8Xwi
         IfNe8gcPmzQEz49ziP3A0tB2ujtoQMaPtcsZ0=
Message-ID: <6a89f9d50808061109y3e68f0a0lc9b4bf289fd308cf@mail.gmail.com>
Date: Wed, 6 Aug 2008 20:09:58 +0200
From: "Stephane Marchesin" <marchesin@icps.u-strasbg.fr>
To: "Keith Packard" <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "John Stoffel" <john@stoffel.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1218045409.24714.257.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <Pine.LNX.4.64.0808041855050.5717@blonde.site>
	 <1217877645.24714.87.camel@koto.keithp.com>
	 <Pine.LNX.4.64.0808042055240.17041@blonde.site>
	 <18583.47633.987143.236236@stoffel.org>
	 <1217910505.24714.152.camel@koto.keithp.com>
	 <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com>
	 <20080806102437.2d5e5d11@infradead.org>
	 <6a89f9d50808061032k6c30887cg6bed0259f9620b1b@mail.gmail.com>
	 <1218045409.24714.257.camel@koto.keithp.com>
X-Google-Sender-Auth: 0cc0ffb40bef9298
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/08, Keith Packard <keithp@keithp.com> wrote:
> On Wed, 2008-08-06 at 19:32 +0200, Stephane Marchesin wrote:
>
>  > Right, but the current code will basically force the discrete card
>  > drivers to implement backing store for all allocations.
>
>
> Aside from not really forcing discrete card drivers to to anything
>  (they're welcome to use or not use this stuff as they prefer), I believe
>  discrete cards will need backing store to support paging objects to disk
>  and suspend-to-ram operations.

Well there is no real other clean way than backing store...

>
>
>  >  Do we want
>  > this ? Also, for cards that can handle page-based memory allocations,
>  > there is no way to make use of this feature, do we want this too ?
>
>
> I don't see how any of the current code directs how future drivers might
>  work; the user-level interface is reasonably abstract and should allow
>  all kinds of internal organizations.
>
>  Instead of complaining that the current code might not support some
>  abstract hardware, please build something that does work and we'll see
>  how to merge that with code for other drivers.
>

Well, this "abstract hardware" is in stores, it's called G80 and R600.
If intel can't do something on its hardware shouldn't prevent others
from using it. And I seriously doubt even the current interfaces would
be fit for this.

Stephane
