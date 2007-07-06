Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbXGFU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbXGFU6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbXGFU56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:57:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:30446 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794AbXGFU55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aiySPlC32vGDeY5EenQX+KQCmQRHHozyIIzdQjfGaVbbrShPGXx0uU9hKX4WTe4OyFdjjpDldqz1PMkiw0PcDM4BCUxs1E4Bw8zY+sLEdpHlGtMSsAJzNpo0jxaQUzXTJlZgt0+997Hsx/RKLU1JKn+PiI1Zi1003UAHGJsnaAw=
Message-ID: <dda83e780707061357p798531cbw29758ccf98df60cc@mail.gmail.com>
Date: Fri, 6 Jul 2007 13:57:54 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] slub: don't export static kmem_cache_open
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1183743340.3779.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1183628260.3818.31.camel@johannes.berg>
	 <Pine.LNX.4.64.0707061028001.30516@schroedinger.engr.sgi.com>
	 <1183743340.3779.11.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-07-06 at 10:29 -0700, Christoph Lameter wrote:
> > On Thu, 5 Jul 2007, Johannes Berg wrote:
> >
> > > kmem_cache_open is static so shouldn't be exported.
> > >
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >
> > I already fixed that. Patch is in Andrew's tree.
>
> Oh good. I actually got build problems from that due to a powerpc64 gcc
> bug so... :)
>
> johannes
>
>

this also looks to solve booting issue on a g4 mac mini also
