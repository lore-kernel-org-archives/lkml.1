Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbXGKFn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbXGKFn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbXGKFnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:43:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:19323 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbXGKFnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jjLLEfdwz0jYbOL27rirIjIDP2BV8OaHezAzxEjX4kcEze+zIKFhPRrur0rq/+8XJTvyDpXoPNU/VzP8WvZ2/rQYxS/ogP1A0T5yXwvRBl8qZ+MfxcdCxBOZgyfWIp8XZ9XQbvlLvu6K+a+kyuf/dAwm5mgTAoXcThlJ0+PxBz4=
Message-ID: <8d6898730707102243t60861fdar147f052501c31958@mail.gmail.com>
Date: Wed, 11 Jul 2007 11:13:20 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: Reading a physical memory location
Cc: "vraghavan3@mail.gatech.edu" <vraghavan3@mail.gatech.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184010444.469290cce48df@webmail.mail.gatech.edu>
	 <8d6898730707091539y14cf5afbsed7ed769526da0a1@mail.gmail.com>
	 <1184091142.4693cc06850f7@webmail.mail.gatech.edu>
	 <1a297b360707101502t2670f0d7g5197b9c32ecb967c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Which is your platform ?

Which processor?

If you want to use physical address directly, then disable MMU. That
is not possible in linux.

Nobin

On 7/11/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 7/10/07, vraghavan3@mail.gatech.edu <vraghavan3@mail.gatech.edu> wrote:
> >
> > Thanks for the quick reply. But I was wondering as to why I would have to map
> > the physical address to the virtual address when I know that the string is
> > permanently in the physical memory because its loaded into flash. Is there a way
> > to directly read from the physical memory location? Also, do the functions
> > ioremap() and readl(va) work when called from within a kernel module?
> >
>
> Of course, if you look at almost any of the memory mapped device
> drivers, you will find that ioremap/readl/writel is the backbone of
> your infrastructure.
>
>
> Manu
>
