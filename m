Return-Path: <linux-kernel-owner+w=401wt.eu-S940004AbXG3VMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940004AbXG3VMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939471AbXG3VMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:12:20 -0400
Received: from lucidpixels.com ([75.144.35.66]:60031 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939383AbXG3VMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:12:19 -0400
Date: Mon, 30 Jul 2007 17:12:17 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Miklos Szeredi <miklos@szeredi.hu>
cc: a1426z@gawab.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
       linux-raid@vger.kernel.org
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on
 software raid 5
In-Reply-To: <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0707301712030.7153@p34.internal.lan>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
 <200707302207.02672.a1426z@gawab.com> <E1IFb5f-00006O-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Miklos Szeredi wrote:

>> Extrapolating these %cpu number makes ZFS the fastest.
>>
>> Are you sure these numbers are correct?
>
> Note, that %cpu numbers for fuse filesystems are inherently skewed,
> because the CPU usage of the filesystem process itself is not taken
> into account.
>
> So the numbers are not all that good, but according to the zfs-fuse
> author it hasn't been optimized yet, so they may improve.
>
> Miklos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This was performed on an E6300, 1 core was ZFS/FUSE (or quite a bit of it 
anyway)

