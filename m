Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbYDCEQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbYDCEQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 00:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYDCEQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 00:16:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:46679 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYDCEQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 00:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d3JSQnB50HQXBmVYEwbSDtpPpHB9Hj4l/+ZeabPcNizyYnMLgSKdFyrDV1WVr2Su9i3d90yvBznO1DsBoC/Vktz2scdcd7J+SP3recDyMiXqpkTjLsY5vIW+YSm2uWbWCapra5EQ9YEG0wPR5dmtZoyvC9EPgTCG9zq6gg8A/zA=
Message-ID: <86802c440804022116j2a8fb745pf734f61542a8e287@mail.gmail.com>
Date: Wed, 2 Apr 2008 21:16:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: make mem_map allocation continuous v2.
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Badari Pulavarty" <pbadari@us.ibm.com>, michael@ellerman.id.au,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080402192223.5e8754a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804021525.48799.yhlu.kernel@gmail.com>
	 <20080402155247.5e746be7.akpm@linux-foundation.org>
	 <86802c440804021744m7c6e3d94vcb6af3ebcaa71b5b@mail.gmail.com>
	 <200804021830.24563.yhlu.kernel@gmail.com>
	 <20080402192223.5e8754a0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 7:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 2 Apr 2008 18:30:24 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > v2 replace:
>  >       [PATCH] mm: make mem_map allocation continuous.
>  >       [PATCH] mm: allocate section_map for sparse_init
>  >       [PATCH] mm: allocate usemap at first instead of mem_map in sparse_init
>  >
>
>  err, no.
>
>
>  >
>  > diff --git a/mm/sparse.c b/mm/sparse.c
>  > index f6a43c0..2881222 100644
>  > --- a/mm/sparse.c
>  > +++ b/mm/sparse.c
>
>  Sorry, but I'd rather not do it this way.  We presently have this:
>

it replaces

>  mm-make-mem_map-allocation-continuous.patch
>  mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
>  mm-allocate-section_map-for-sparse_init.patch
>  mm-allocate-section_map-for-sparse_init-update.patch
>  mm-allocate-section_map-for-sparse_init-update-fix.patch
>  mm-allocate-section_map-for-sparse_init-powerpc-fix.patch

others still needed

so mm-make-mem-map-allocation-continuous.patch will not break powerpc and ia64

YH
