Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXIUL2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXIUL2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXIUL1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:27:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:62902 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbXIUL1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=D8/+NAqIP7u1dl6n+TBgO211IhM7EOCTiQnn/R/Q7sf5rZ+ZWMFUHbDnGa19kv8cwdh4Ix+OerbLhr9kBUbDe+F+ynrd4VupFh0wNOLZmXob0kGKb4AwMV2j9l1AtyabeVpPA+OvWPPZeG4EVYNgB0ZEChReUYfm5vaJ05OREwk=
Message-ID: <46F3AAC1.5050409@gmail.com>
Date: Fri, 21 Sep 2007 16:28:01 +0500
From: Muhammad Tayyab <mail.tayyab@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Peter Stahlir <peter.stahlir@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Git as a filesystem
References: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com>
In-Reply-To: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I think it would be a bad idea to use Git as a part of filesystem. If 
someone wants to install it and use it, its his choice, but if we make 
it the part of Filesystem, and just use it for compression, this will 
reduce the performance.
   For compression, i think more preferable is to make a patch for ext3 
that implements the compression, like compression patch for ext2.

    On the other hand I liked the idea that we can have a Git based file 
system with special (non-standard) features. Why not provide the 
features like repository and other Git features in normal file system.

Thanks,

-- Tayyab




Peter Stahlir wrote:
> Hi!
>
> Is it possible/feasible to use git as a filesystem?
> Like having git on top of ext3.
>
> This way I could do a gitfs-gc and there is only one
> pack file sitting on the disk which is a compressed
> version of the whole system.
> I am not interested in a version controlled filesystem,
> only in the space saving aspects.
>
> Thanks,
>
> Peter
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

