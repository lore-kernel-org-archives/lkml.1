Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbXGIWjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbXGIWjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXGIWjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:39:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26780 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbXGIWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BXWhRv//NJYePbM9Jt6s6la7seL9Cgrzp7Sz4WvOZRthzuuMuzgpnAblpeg7R3pWLM2GY5zR3j5+YGUJn6rRUoOH95RgoEvDnrHOGQgDcWUd6CXmks+WkBCS8MWLUab2J3zcXN2+WdJZuFnqtvIIjoW6aZ1UQ7jRe+X2IMaCMZk=
Message-ID: <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
Date: Tue, 10 Jul 2007 04:09:40 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>
Subject: Re: Reading a physical memory location
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1184010444.469290cce48df@webmail.mail.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
        If you know the physical address, then you get virtual address
from that physical adress by using ioremap().

Then you can use readl(virtualaddress) to read the string from there

Nobin Mathew

On 7/10/07, vraghavan3@mail.gatech.edu <vraghavan3@mail.gatech.edu> wrote:
>
>
> --
> Hey all,
>
> I know the physical address of a string which is loaded into flash memory. I
> want to read the string at the known physical memory location from within a
> kernel module. I initially tried reading the "/dev/mem" file using open(),
> lseek() and read(). But I guess its not possible to call these functions from a
> kernel module.
>
> Is there some way of reading the contents of this physical memory location from
> within a kernel module?
>
> Thank You
> Veena
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
