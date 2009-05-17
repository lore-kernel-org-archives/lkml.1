Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZEQKdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZEQKdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZEQKdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:33:08 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47558 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZEQKdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=nN2usvbC+YJWlWfB8a3ZCTuswCT1mP7FNuBSITZUJRjPOxfEC3yWpd7owIygnsJBwU
         e30varXaSq3uuIU9AlmwvDDya/0MuS3TuyvMHeMqdH0JemZIbMP61d9nm8mSP59RFDBC
         8xzUlsS6ZYTPaRv6kQUYT/Vld7CtxlA81TYvY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/15 v2] ide-atapi: remove pc->buf and misc cleanups
Date: Sun, 17 May 2009 12:36:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com> <200905162107.38332.bzolnier@gmail.com> <4A0F3963.8050000@kernel.org>
In-Reply-To: <4A0F3963.8050000@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905171236.15366.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ So long with my idyllic ide git tree experience... ]

On Sunday 17 May 2009 00:08:35 Tejun Heo wrote:
> Bartlomiej Zolnierkiewicz wrote:
> >> It also got rebased ontop of block/for-2.6.31 after Tejun's stuff got merged.
> ...

"..." == a lot of merge conflicts...

> > Looking at creation dates I suspect that somewhere along the way
> > something was rebased?
> > 
> > One quick temporary solution would be to recreate bp/pc-remove-buf
> > on top of tj/block-peek-fetch...

...which are coming up before tj/block-peek-fetch and which simply
shouldn't be there since there were no further modifications to these
files in ide-2.6.git/for-next

> Oh.. please use block commit.  Jens didn't pull in my tree but applied
> patches on top of the block tree, so my commits shouldn't be in any
> official trees.

I took a closer look and it seems the same is true for your earlier IDE
patchsets...  IOW they were also applied on top of block tree even though
your commits have been pulled into ide-2.6.git/for-next long before.

This seems to be wrong in terms of git usage and definitely is not what
we have agreed on w.r.t. handling of those patchsets.

Jens?
