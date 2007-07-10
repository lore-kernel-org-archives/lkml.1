Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXGJWCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXGJWCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 18:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbXGJWC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 18:02:27 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:54874 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758380AbXGJWC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 18:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Na0KONtL3rbxV1WrNWVERnQ5hgfGIQyXbEILcEoOIcc4rX23kgW8FzdDm50HTAlj9vmQIhEaKTL8rmBv+cIobZbbkbO6cH9PJrWkwfBw0nhx/KQf1xSp0z0pKHgEeFY2VFVGt0SfxSkTNdQgip7uXEbOQi3+ka/I/2NskOanIyU=
Message-ID: <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>
Date: Wed, 11 Jul 2007 02:02:23 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>
Subject: Re: Reading a physical memory location
Cc: "Nobin Mathew" <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>
	 <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
	 <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, vraghavan3@mail.gatech.edu <vraghavan3@mail.gatech.edu> wrote:
>
> Thanks for the quick reply. But I was wondering as to why I would have to map
> the physical address to the virtual address when I know that the string is
> permanently in the physical memory because its loaded into flash. Is there a way
> to directly read from the physical memory location? Also, do the functions
> ioremap() and readl(va) work when called from within a kernel module?
>

Of course, if you look at almost any of the memory mapped device
drivers, you will find that ioremap/readl/writel is the backbone of
your infrastructure.


Manu
