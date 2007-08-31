Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbXHaQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbXHaQIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbXHaQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:08:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:50790 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbXHaQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bu8IPZ71jmqOaz9oR003OHbEHjxG8vrEVBVaGY5PyoU8o90fo/xUAsXs/IcZICwbKmcIVpjzvu5gqHZ6CL9FrEuvuaGqbIlINWRJKIk2C5d/cbz8zhsJAo47YAWe+o5pWjKVQX6+9Hx7wWupUpF8NRU5K3e7CkRKoOHHQb9WLNI=
Message-ID: <ab40e9c0708310908o38633ecpdbcae78aca15946f@mail.gmail.com>
Date: Fri, 31 Aug 2007 18:08:04 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Uli Luckas" <u.luckas@road.de>
Subject: Re: parse_tag_ramdisk
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200708301846.09669.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708300707r2e6d2d71y42940084db5038ac@mail.gmail.com>
	 <200708301806.42905.u.luckas@road.de>
	 <ab40e9c0708300910m3cba4c7bie3f6c9d471a155ff@mail.gmail.com>
	 <200708301846.09669.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uli,

thanks ,

I just found in the bootloader I used "go" to access the kernel, maybe
the problem is caused by this, I will check it further.
by the way, do you know how to setup the address of the ramdisk in the
bootloader? I used bootm kernel_address ramdisk_address.

is this enough?

regards,

Yang


2007/8/30, Uli Luckas <u.luckas@road.de>:
> On Thursday, 30. August 2007, Xu Yang wrote:
> > Hi Uli,
> >
> >
> > thanks for your reply.
> >
> > just have a question, where is the tag list, how can i modify this?
> >
> If you don't know where the list is created, how do you now that it contains a
> ramdisk tag? There is a chance, that the kernel does not even get a ram disk
> tag at all. This would also explain, why it is not parsed ;-)
>
> The tag list is supplied by your bootloader. How the bootloader creates the
> list and how to change the order depends on your bootloader. You probably
> have to read (and patch) it's source code.
>
> regards,
> Uli
>
> --
>
> ------- ROAD ...the handyPC Company - - -  ) ) )
>
> Uli Luckas
> Software Development
>
> ROAD GmbH
> Bennigsenstr. 14 | 12159 Berlin | Germany
> fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
> url: www.road.de
>
> Amtsgericht Charlottenburg: HRB 96688 B
> Managing directors: Hans-Peter Constien, Hubertus von Streit
>
