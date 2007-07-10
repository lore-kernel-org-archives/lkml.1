Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXGJSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXGJSOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbXGJSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:14:13 -0400
Received: from deliverator5.gatech.edu ([130.207.165.165]:37571 "EHLO
	deliverator5.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbXGJSOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:14:12 -0400
Message-ID: <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
Date: Tue, 10 Jul 2007 14:12:22 -0400
From: vraghavan3@mail.gatech.edu
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reading a physical memory location
References: <1184010444.469290cce48df@webmail.mail.gatech.edu> <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
In-Reply-To: <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 64.102.85.146
X-Authenticated-User: vraghavan3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the quick reply. But I was wondering as to why I would have to map
the physical address to the virtual address when I know that the string is
permanently in the physical memory because its loaded into flash. Is there a way
to directly read from the physical memory location? Also, do the functions
ioremap() and readl(va) work when called from within a kernel module?

-- Veena



Quoting Nobin Mathew <nobin.mathew@gmail.com>:

> Hi,
>         If you know the physical address, then you get virtual address
> from that physical adress by using ioremap().
>
> Then you can use readl(virtualaddress) to read the string from there
>
> Nobin Mathew
>
> On 7/10/07, vraghavan3@mail.gatech.edu <vraghavan3@mail.gatech.edu> wrote:
> >
> >
> > --
> > Hey all,
> >
> > I know the physical address of a string which is loaded into flash memory.
> I
> > want to read the string at the known physical memory location from within a
> > kernel module. I initially tried reading the "/dev/mem" file using open(),
> > lseek() and read(). But I guess its not possible to call these functions
> from a
> > kernel module.
> >
> > Is there some way of reading the contents of this physical memory location
> from
> > within a kernel module?
> >
> > Thank You
> > Veena
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


--

