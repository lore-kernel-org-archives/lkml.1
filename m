Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbYCXSQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbYCXSQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbYCXSPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:15:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:41560 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbYCXSPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=piXPZUuyLbMiFwuxKKy6hoR3OslMIY8Uo+YnCQprZtUsNHPanuFhNoybTbCfsSjcoEJkjLWk+Sv3oTReinaJZCjYRwS3H16o4pmjz2s18ic2la7QMjyl5z4AoGhO28eKCuQtH1tYj2UBgLdX4trDWfC7jaJIwHYfRfy6JD1THJE=
Message-ID: <4cefeab80803241115l34b37b33ie9eec5404ff8a764@mail.gmail.com>
Date: Mon, 24 Mar 2008 23:45:51 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
Subject: Re: [PATCH 0/6]: compcache: Compressed Caching
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <5699f8f00803240921j5dc66547xf9a755ee531d8476@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242030.05997.nitingupta910@gmail.com>
	 <5699f8f00803240921j5dc66547xf9a755ee531d8476@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 9:51 PM, Wander Winkelhorst
<w.winkelhorst@gmail.com> wrote:
>
> On Mon, Mar 24, 2008 at 4:00 PM, Nitin Gupta <nitingupta910@gmail.com>
> wrote:
> > Hi All,
> >
>
> Hi,
>
>
> > (sending to lkml since I didn't get any reply at linux-mm).
> >
> > This implements a RAM based block device which acts as swap disk.
> > Pages swapped to this disk are compressed and stored in memory itself.
> > This allows more applications to fit in given amount of memory. This is
> > especially useful for embedded devices, OLPC and small desktops
> > (aka virtual machines).
> >
>
> I think this is a very interesting patch, but I find the name confusing, it
> isn't actually a compresed cache, now is it? It's just a compressed ramdisk.

In future, I intend to extend it to include page-cache compression also.

> Is it possible to use it as a initramfs as well?
I guess not since R/W have to be page-aligned in this case.

>  How many can I run at the same time?
>

Only 1 for now :)


>
> >
> > Project home: http://code.google.com/p/compcache/
> >
>
> This page shows the usage as:
>
> Loading: run 'use_compcache.sh <size of swap device (KB)>' to load all
> required modules and setup swap device. If size is not specified, default
> size of 25% of RAM is used.
>
> Does that mean that if I load compcache without using it, I still lose 25%
> of my memory? Or is the memory dynamically allocated?
>

Memory is dynamically allocated.


Thanks,
Nitin


> Regards,
> Wander Winkelhorst
>
