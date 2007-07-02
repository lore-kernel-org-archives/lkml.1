Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXGBCVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXGBCVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 22:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbXGBCVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 22:21:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:56569 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbXGBCVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 22:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=moMeHRD/JToB/KsYEiFWNkJjxT3EytXfQexrvClsk9gyejyh7qFyGQsoxEA2vG2Y+/q8jGfWk/jwjz/sZTbUpr3UVLQws1Zs0YOJ5jq+ZnIq8iiP/xai0L2HTjfyzbM7oQ+yQyMJqpwL0XysxofdqqzmpWYTsJmp/sZpE7ty4FA=
Message-ID: <a781481a0707011921j518d29b8q77438921a41504c5@mail.gmail.com>
Date: Mon, 2 Jul 2007 07:51:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Josef Sipek" <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [-mm patch] unionfs: make functions static
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070702014249.GA14417@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	 <20070701202330.GU10869@stusta.de>
	 <20070702014249.GA14417@filer.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Cc:'s trimmed ]

On 7/2/07, Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:
> On Sun, Jul 01, 2007 at 10:23:30PM +0200, Adrian Bunk wrote:
> > This patch makes some needlessly global functions static.
> >
> ...
> > --- linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c.old      2007-07-01 00:05:02.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c  2007-07-01 00:06:05.000000000 +0200
> > @@ -18,6 +18,8 @@
> >
> >  #include "union.h"
> >
> > +static int realloc_dentry_private_data(struct dentry *dentry);
> > +
> >  /* is the filename valid == !(whiteout for a file or opaque dir marker) */
>
> I forget who said it, but someone wasn't very happy with prototypes like
> that in .c files. What's the prefered way - are they ok for static symbols?

The preferred way is to push static functions' definitions above the
callsites (caller functions) in the same file, if possible.
Perhaps Adrian was in a hurry so didn't do that ...

Satyam
