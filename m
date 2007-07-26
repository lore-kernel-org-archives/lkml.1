Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXGZGXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXGZGXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXGZGXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:23:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:16805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbXGZGXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r1NZ39GPOC1N3nZ37xM2lIo6++3XJVPzzOzH4tOtCVekSfcIlgFNNwj8yOG2wTFZiRYtNg+tHO1VBcr6eGQJMqsruvgl4MPnyvaSPecFB30w83aChL35h2wLFDrqTLOIv2afTTnvBOd+7ufyQhx3jYh3AYa78I1ILJy+6v4kyX0=
Message-ID: <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:23:03 +0700
From: "Andika Triwidada" <andika@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: updatedb
Cc: "Robert Deaton" <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       "ck list" <ck@vds.kolivas.org>, linux-mm@kvack.org
In-Reply-To: <46A81C39.4050009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
	 <46A773EA.5030103@gmail.com>
	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>
	 <46A81C39.4050009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 07/25/2007 07:15 PM, Robert Deaton wrote:
>
> > On 7/25/07, Rene Herman <rene.herman@gmail.com> wrote:
>
> >> And there we go again -- off into blabber-land. Why does swap-prefetch
> >> help updatedb? Or doesn't it? And if it doesn't, why should anyone
> >> trust anything else someone who said it does says?
>
> > I don't think anyone has ever argued that swap-prefetch directly helps
> > the performance of updatedb in any way
>
> People have argued (claimed, rather) that swap-prefetch helps their system
> after updatedb has run -- you are doing so now.
>
> > however, I do recall people mentioning that updatedb, being a ram
> > intensive task, will often cause things to be swapped out while it runs
> > on say a nightly cronjob.
>
> Problem spot no. 1.
>
> RAM intensive? If I run updatedb here, it never grows itself beyond 2M. Yes,
> two. I'm certainly willing to accept that me and my systems are possibly not
> the reference but assuming I'm _very_ special hasn't done much for me either
> in the past.

Might be insignificant, but updatedb calls find (~2M) and sort (~26M).
Definitely not RAM intensive though (RAM is 1GB).

>
> The thing updatedb does do, or at least has the potential to do, is fill
> memory with cached inodes/dentries but Linux does not swap to make room for
> caches. So why will updatedb "often cause things to be swapped out"?
>

[ snip ]
