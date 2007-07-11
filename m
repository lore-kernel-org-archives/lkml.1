Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXGKIZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXGKIZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 04:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXGKIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 04:25:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:40281 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbXGKIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 04:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GyoAVPjcDDatqlO9j+1dXvfxbDFoWcj3PbTpztOGbpCtYHsTSweMKh29w+wBg++lslBl8dOHxhwEZ6tQfbXzSPjVLWFSjjW8tt5aLJUsAXCqU8zIZ8D1PnpucN+6VFZuDoWcL1hQIkyHMIQxxjt/tfTj3dLGCnBJCAxNJnD/GWo=
Message-ID: <1a297b360707110111u25a786c5m4857673e3e1b90a1@mail.gmail.com>
Date: Wed, 11 Jul 2007 12:11:38 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Nobin Mathew" <nobin.mathew@gmail.com>
Subject: Re: Reading a physical memory location
Cc: "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <8d6898730707102243t60861fdar147f052501c31958@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>
	 <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
	 <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
	 <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>
	 <8d6898730707102243t60861fdar147f052501c31958@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/07, Nobin Mathew <nobin.mathew@gmail.com> wrote:
> Which is your platform ?
>
> Which processor?
>
> If you want to use physical address directly, then disable MMU. That
> is not possible in linux.

ioremap does map io memory using phys_to_virt
I thought phys_to_virt was enough to remap physical memory to virtual
http://mirror.linux.org.au/linux.conf.au/2005/cdrom-beta-1/linux-mandocs-2.6.12.6/phys_to_virt.html



>
> Nobin
>
> On 7/11/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > On 7/10/07, vraghavan3@mail.gatech.edu <vraghavan3@mail.gatech.edu> wrote:
> > >
> > > Thanks for the quick reply. But I was wondering as to why I would have to map
> > > the physical address to the virtual address when I know that the string is
> > > permanently in the physical memory because its loaded into flash. Is there a way
> > > to directly read from the physical memory location? Also, do the functions
> > > ioremap() and readl(va) work when called from within a kernel module?
> > >
> >
> > Of course, if you look at almost any of the memory mapped device
> > drivers, you will find that ioremap/readl/writel is the backbone of
> > your infrastructure.
> >
> >
> > Manu
> >
>
