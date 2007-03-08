Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXCHVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXCHVDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933315AbXCHVDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:03:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:56707 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbXCHVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:03:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UFuy28bUjuW6fbGCqr+HUFZX1uJkAyj6k5t5Dgup/rkRM1S1RzgVkUIqpJ6/zht+paxXwTgI09wL/75ppZboFNZbCMJuleHzw+G8xqjBuRSngd9SydC6+hDsDEM1vi9jiZ/rrcoaqrQubRfHkV4vobpcmnDIhzjD3TqXjqzT4cw=
Message-ID: <9c21eeae0703081303t576e8757t259380092894ced5@mail.gmail.com>
Date: Thu, 8 Mar 2007 13:03:48 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Anton Blanchard" <anton@samba.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
In-Reply-To: <20070308175729.GA7054@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
	 <20070306092917.GA5226@infradead.org>
	 <200703080318.04631.zippel@linux-m68k.org>
	 <20070308090031.GB7373@infradead.org>
	 <1173369229.3550.2.camel@laptopd505.fenrus.org>
	 <20070308160852.GB9916@infradead.org> <45F0426C.8000009@zytor.com>
	 <20070308175729.GA7054@kryten>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Anton Blanchard <anton@samba.org> wrote:
>
> > By the way, it's a massive snafu that the swap area magic number is
> > dependent on PAGE_SIZE.  There is absolutely no good reason for that.
>
> Agreed, its been a big problem booting between 4kB and 64kB kernels on
> ppc64.

Okay this really seems like a couple of things need to happen, first
change swap dependency on PAGE_SIZE, then move the __KERNEL__ define
above the PAGE_SIZE and friends defines in the appropriate
asm-*/page.h files.

Do these tasks need to happen in this order? I haven't really looked
at the swap code at all...

Also, I'd be willing to help I've done kernel coding for experimental
projects and such but nothing for kernel.org so I might need some
shepherding.

- David Brown
