Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYFJPJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYFJPJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYFJPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:09:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:30997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYFJPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gDx0i8Ep/lKI8yacHf58frAEbEGYqy8UWjhOWX/dsVKeuPNqA9jPY/PKTG8/OnHphH
         rxkcsnAhvZcqxP1zYwsx3EEW+ssjU/wqD229xkOKM6zDKDS2DecBtcUE8yJIKTNb7tx9
         xPU/GSYRme4tW4c2ZCJ4tL6d9aP+/YO/qV5gc=
Message-ID: <19f34abd0806100809j6d26f62bte961a34b2c448f3c@mail.gmail.com>
Date: Tue, 10 Jun 2008 17:09:43 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Miles Lane" <miles.lane@gmail.com>, "Michael Buesch" <mb@bu3sch.de>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0806100742t1bd275dib43c5d72b3dd9659@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <19f34abd0806100729h7a060012h91e81248c9c7cdca@mail.gmail.com>
	 <200806101634.21576.mb@bu3sch.de> <200806101637.11473.mb@bu3sch.de>
	 <a44ae5cd0806100742t1bd275dib43c5d72b3dd9659@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/08, Miles Lane <miles.lane@gmail.com> wrote:
> Sorry, I forgot to label the kernel tree.  It is 2.6.26-rc5-mm2.

No worries, it was in your config file :-)

Thanks for reporting.


On 6/10/08, Michael Buesch <mb@bu3sch.de> wrote:
> Ok, FUJITA Tomonori, please make sure a patch like the following goes
>  into the same trees that you submitted commit 353c409 to.
>  Also make sure to check b43legacy. I _guess_ you might have added
>  the same bug there.

Can you please also make sure that Miles Lane appears with a
Reported-by line in your patch? Thanks :-) Also: Nice fix!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
