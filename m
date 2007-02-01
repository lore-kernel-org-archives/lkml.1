Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXBAWrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXBAWrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbXBAWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:47:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:48989 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbXBAWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K+lecCbrr0B8ZzqMo/uHedKH7MMXhoFjEatAtOtfqAK0ybTkgBjleonFcFxwTNnBLHR75nLjcTzoBtqW3sjU0PdK6Tjl4rmlaVqCAIsveMoQkxE+vcyMbblqagGNSkKjGTODzzzuxRWuxONYxanjgrktukGXKJ3wfhRCFzCrxbY=
Message-ID: <311601c90702011447n673f7508vc28a7d3bf31bc8d8@mail.gmail.com>
Date: Thu, 1 Feb 2007 15:47:05 -0700
From: "Eric D. Mudama" <edmudama@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by probe of partitions
Cc: TJ <linux@tjworld.net>, "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Neil Brown" <neilb@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070201142648.7d16e4b6.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170287439.13764.24.camel@butch.lan.tjworld.net>
	 <20070201142648.7d16e4b6.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Andrew Morton <akpm@osdl.org> wrote:
> Also, from reading the replies I think we'd like to see some more
> explanation of why this is necessary: are you really really sure that those
> disks were incorrectly handling illegal sector numbers?  Knowing the IBM
> and Maxtor model numbers might be useful.

I'd like to know the model numbers (and firmware revisions) too.

The drive knows how many LBAs it has, and making sure the span of the
command is within the valid LBA space is one of the first things
checked.

Another possibility of for clunking is if the drive is damaged and
cannot track follow in a region, the drive will go to the latch and
push off repeatedly attempting to reacquire servo information.  That
can be scary sounding if you haven't heard it before.

Not saying the bug is impossible, but I'd like to know more.

--eric
