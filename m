Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbZG3Kkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbZG3Kkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZG3Kka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:40:30 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:38139 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZG3Kk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QgzpcWRiHfMkwDJFH1WeCcP1gf7Ol8YvsV1DCAr5AqT///8vqe1EVdrytpINuKNkyk
         iQ54MLHeDy3z6gBkqtBzP7v6+LMFPLJTmsdOfpimGhe9AaHgPFT4orfQQwNxtGyrkrJt
         RaUHmfY1FyedEYURmsDFRvnLj+d3pLqC15ujo=
MIME-Version: 1.0
In-Reply-To: <200907251833.42598.elendil@planet.nl>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
	 <21d7e9970907081642l3ef6df5blde31df656cd74432@mail.gmail.com>
	 <200907090328.53643.elendil@planet.nl>
	 <200907251833.42598.elendil@planet.nl>
Date: Thu, 30 Jul 2009 20:40:29 +1000
Message-ID: <21d7e9970907300340t79e063e1n18cdba11538c2fdc@mail.gmail.com>
Subject: Re: [Bug #13667] drm: display arifacts when X.Org is stopped
From: Dave Airlie <airlied@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 26, 2009 at 2:33 AM, Frans Pop<elendil@planet.nl> wrote:
> On Thursday 09 July 2009, Frans Pop wrote:
>> > However we shall endeavour to fix this issues as it may be systemic
>> > of something else going wrong in the new PAT/AGP code.
>>
>> Great. Thanks in advance, I do appreciate it.
>
> Any news on this?\

http://git.infradead.org/users/dwmw2/iommu-agp.git

don't suppose you could pull that tree in and see if it helps?

Dave.

>
>> BTW, today I noticed another regression, but I have not yet looked into
>> it deeply. When I suspend I normally see at least some console messages
>> from the suspend procedure on the framebuffer console, but with .31-rc2
>> I only see a cursor. It does not really affect the suspend/resume.
>> Could possibly be related. Will investigate further.
>
> This turned out to be unrelated, and is actually an improvement. It's a
> logical result of a printk patch I submitted (for .32):
> http://lkml.org/lkml/2009/7http://lkml.org/lkml/2009/7/6/108/6/108
>
> Cheers,
> FJP
>
