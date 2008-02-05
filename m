Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYBETC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYBETC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbYBETCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:02:11 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:2222 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759455AbYBETCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uA67ByiVCUMd8IAM9/Tu5UwdBCZ9Vs7fM+VQ7amDHalZqKOchgvdmunODH1ZRMA/urnspB7mGHGorHv4PKoYHaEJY0lED2Hg8635cRwCt85lYV37FoCUy8R8VvwEXq7yfoIsNSH4uxt7a6n6dvoaWggRLzLwy1BWSbRt0/FIu2o=
Message-ID: <e2e108260802051102y1b02bcdic5ea9c45caee9964@mail.gmail.com>
Date: Tue, 5 Feb 2008 20:02:06 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Erez Zilber" <erezz@voltaire.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>,
       James.Bottomley@hansenpartnership.com,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <47A89889.9060701@Voltaire.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <47A89889.9060701@Voltaire.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 6:10 PM, Erez Zilber <erezz@voltaire.com> wrote:
> One may claim that STGT should have lower performance than SCST because
> its data path is from userspace. However, your results show that for
> non-IB transports, they both show the same numbers. Furthermore, with IB
> there shouldn't be any additional difference between the 2 targets
> because data transfer from userspace is as efficient as data transfer
> from kernel space.
>
> The only explanation that I see is that fine tuning for iSCSI & iSER is
> required. As was already mentioned in this thread, with SDR you can get
> ~900 MB/sec with iSER (on STGT).

My most recent measurements also show that one can get 900 MB/s with
STGT + iSER on an SDR IB network, but only for very large block sizes
(>= 100 MB). A quote from Linus Torvalds is relevant here (February 5,
2008):

    Block transfer sizes over about 64kB are totally irrelevant for
99% of all people.

Please read my e-mail (posted earlier today) with a comparison for 4
KB - 64 KB block transfer sizes between SCST and STGT.

Bart Van Assche.
