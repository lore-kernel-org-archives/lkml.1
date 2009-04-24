Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZDXTSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZDXTSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZDXTSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:18:13 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:46861 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZDXTSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ev8Fg9oVpdsvICL/iVto1YlQ5DIfC+ZRRwtfW32mvQeJhBfqi7zAIYfDM6b3EedqZQ
         ew8445LfLsc8t+QloyTapyR59UtdGg7u/r8qp3bw+Ix/9D/M3KK4X6MmGV7PIoQHt1Ah
         MtoI0Cg+s+9MWimEmCaplSkPb000nuYklfw9k=
MIME-Version: 1.0
In-Reply-To: <20090422140107.GD3288@tuxdriver.com>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
Date: Fri, 24 Apr 2009 21:18:09 +0200
Message-ID: <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com>
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/22 John W. Linville <linville@tuxdriver.com>:
> On Wed, Apr 22, 2009 at 12:33:03PM +0200, Zdenek Kabelac wrote:
>> Hi
>>
>> I'm checking whether -rcX kernel could be usable on my
>> T61/4GB/C2D/x86_64 - but wireless seems to be still out of
>> functionality:
>> I'm getting lots of weird trace-back messages and it looks like
>> iwl3945 is not working at all.
>> (attached messages from fresh build of -rc3 - but it never worked even in -rc1)
>
> Looks like this one did _not_ make -rc3:
>
> commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d
> Author: Reinette Chatre <reinette.chatre@intel.com>
> Date:   Tue Apr 21 10:55:48 2009 -0700
>
>    iwlwifi: DMA fixes
>
>    A few issues wrt DMA were uncovered when using the driver with swiotlb.
> ...
>
> It is in wireless-2.6 and should be in net-2.6 -- please try one of those kernels.


I can confirm that current upstream linux commit
9f5a691253924fd033a58c6b1fed57bb0a4eccf4 works again with iwlwifi.
and it already contains the patch you suggested to check.

Zdenek
