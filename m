Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZHNFoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZHNFoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZHNFoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:44:23 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:58176 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZHNFoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tYuJyyLFhyViYtCc5cCDkMIridfEZm9Pkjrhw5lMX4LT24ObFCzfejJL7VMRgW3Qv6
         K4UJiFPDpeMk1zAtIw4hQ5hTb6S/fRi+mXQoSKMTqI5KEvSQwIh3kxkxn1eb/PA8gYyx
         uOI57B0lvJGV7LGNL1D7dD7xXuPVeOpDqNmCc=
MIME-Version: 1.0
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B3B2F7CB@orsmsx505.amr.corp.intel.com>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
	 <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
	 <1250153373.29180.225.camel@macbook.infradead.org>
	 <3877989d0908130200k6d016a74w1947dc6bcd368a7f@mail.gmail.com>
	 <1250183298.29180.853.camel@macbook.infradead.org>
	 <A6AD88C3F2289247BE726C37303E1EB8B3B2F7CB@orsmsx505.amr.corp.intel.com>
Date: Fri, 14 Aug 2009 13:44:23 +0800
Message-ID: <3877989d0908132244r74020669ldb119a17ff12d442@mail.gmail.com>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: Luming Yu <luming.yu@gmail.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "Luck, Tony" <tony.luck@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 1:30 AM, Yu, Fenghua<fenghua.yu@intel.com> wrote:
>>-----Original Message-----
>>From: David Woodhouse [mailto:dwmw2@infradead.org]
>>Sent: Thursday, August 13, 2009 10:08 AM
>>To: Luming Yu
>>Cc: FUJITA Tomonori; Yu, Fenghua; Luck, Tony; linux-kernel@vger.kernel.org;
>>akpm@linux-foundation.org
>>Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init
>>failure
>>
>>On Thu, 2009-08-13 at 17:00 +0800, Luming Yu wrote:
>>> Yes the flood of dmar_fault on my HP compaq Dc7800u (my x86_64 linux
>>> desktop) has been fixed. But I still have an iommu casued boot problem
>>> on a ia64 box.
>>
>>Really? Even after http://git.kernel.org/linus/51b89f7a6615 ?]
>>
>>Fenghua will be very interested if that's true. I'm not -- I just hate
>>you for having the hardware. :)


-rc5 can't boot.


>>
>
> The latest upstream tree has three patches to fix the iommu boot issue on ia64. Except the above one, the other two patches are:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=33041ec049d39a6e0463c7edc7b6f631d24559e3
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f532959b77e5e567c84c914cb7c7b07d2582448b
>
> Please checkout the latest upstream tree and have a try.


-rc6 can boot. Thanks all for help. I'm satisfied so far. :-)
