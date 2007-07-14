Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbXGNA6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbXGNA6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbXGNA6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:58:15 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:39034 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbXGNA6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PL+3IxZZyObsBHZyMuDjiYfWD0GWkXpZQsVzPh1pJ9Mg6S7bt1eMl0zfcgtbIZ6Ld5i0AcdjzfGtffC8yQh0SoXrZAaYIlXdxiifxwa4zsOXEaGunNOAkhR3rdZyXAKH7Z46Q3SlqmSJfRmiuGfjd168wOiwBBdLo/pBJZApzV8=
Message-ID: <29495f1d0707131758x63b81cc2y44d4f2ac574f3a9b@mail.gmail.com>
Date: Fri, 13 Jul 2007 17:58:12 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
>
> - NOTE (an uppercase one, indeed): there are a lot of menuconfig changes in
>   here which break `make oldconfig' badly.  If you grab an old .config and run
>   `make oldconfig', your kernel probably won't work.  I lost useful things
>   like CONFIG_BLK_DEV and the whole SCSI system, because they were added after
>   I generated my .config.
>
>   So save yourself some hassle and check your .config carefully before
>   building this kernel.  Make sure that everything you need is still enabled.
>
>   I found that manually adding "CONFIG_BLK_DEV=y" to the .config before
>   running oldconfig saved a large number of config items from getting lost.

On the one ppc64 machine I have to test on for memoryless nodes, I
found I had to add back in CONFIG_BLK_DEV=y and
CONFIG_SCSI_LOWLEVEL=y. Just for reference as other folks pull out
their hair.

>   Those menuconfig changes have been a huge pain.

Yes.

Thanks,
Nish
