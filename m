Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZHMJAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZHMJAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZHMJAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:00:38 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:52814 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZHMJAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xBBqjLvVR3gJFYmbTAM9riGGSoK2DZeFYinfRjYcLHnBbS664k91Rd5OKvn9e5RNkg
         deRv+3J7YITKdO60DdJniLVHO19FzmUkz3sCDfvehXwyrI5/HyvYVReDTj/kjUfaVWA7
         BC2W9YQrot9bmZ18KbZHOKOuB9SQWrhHwaruA=
MIME-Version: 1.0
In-Reply-To: <1250153373.29180.225.camel@macbook.infradead.org>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
	 <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
	 <1250153373.29180.225.camel@macbook.infradead.org>
Date: Thu, 13 Aug 2009 17:00:38 +0800
Message-ID: <3877989d0908130200k6d016a74w1947dc6bcd368a7f@mail.gmail.com>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 4:49 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Thu, 2009-08-13 at 16:11 +0800, Luming Yu wrote:
>> I treat this as -32 or -33 stuff, because I don't see a real system is blocking
>> on the problem. I found this problem when I was trying to disable some drhd
>> for debugging a real iommu issue...that one has priority.
>
> (The real bug you were chasing is fixed, isn't it? Or worked around, at
> least, since the BIOS in question is still closed source and broken.)

Yes the flood of dmar_fault on my HP compaq Dc7800u (my x86_64 linux
desktop) has been fixed. But I still have an iommu casued boot problem
on a ia64 box.
