Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbXGGA0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbXGGA0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXGGA0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:26:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60759 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbXGGA0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OWT/yx3L+s0OuAH6vczLnwfpQYBXw+Ks9aXl6ogXcUqqFNqYSGEk3f5z/K9xSdrxzUvH1JdWTqIZOowdh9j9NoZ158dKhAz2BGmvCEkXpJQzZLdV1ISEGyE6CfsFbNobJisSEsA3812le9mBsK+xoy/b9fWdq8zsIFgk6nY98Go=
Message-ID: <dda83e780707061726o56de140avaf85426bb889fe61@mail.gmail.com>
Date: Fri, 6 Jul 2007 17:26:02 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1183761066.3779.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1183628260.3818.31.camel@johannes.berg>
	 <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
	 <1183743340.3779.11.camel@johannes.berg>
	 <dda83e780707061357p798531cbw29758ccf98df60cc@mail.gmail.com>
	 <1183761066.3779.21.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-07-06 at 13:57 -0700, Bret Towe wrote:
> > On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > > Oh good. I actually got build problems from that due to a powerpc64 gcc
> > > bug so... :)
>
> > this also looks to solve booting issue on a g4 mac mini also
>
> Huh? That doesn't really make sense, but who knows what else that gcc
> problem caused.
>
> johannes
>
>

if you want I can revert the patch and make sure thats what caused it
as when i applied this i also updated from cfs v18 to v19
but v18 was working fine before on rc7 i only updated to current -git

way I saw it was
-rc7-cfs-v18 working
-rc7-git-cfs-v18 broken booting with slub
-rc7-git-cfs-v19 working with slub with this patch
