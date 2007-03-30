Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXC3Pqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXC3Pqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXC3Pqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:46:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:32599 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXC3Pqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PpwrAg5dU/nzSwlJlmrVz75im5iaivRl5PHpu/GOaciua3Awdcuft33j/Ymlfuk/sl6rDd9pPN9mk2sALI2IDUXvA/D4PzjQPEBoNxXg6Hz6hAayA3Xj3aUi6FbpXfo+JP1Tr3OqwN07zQHCmZ9FGf9IGOQYDaYNc3jVoH33YGU=
Message-ID: <6d6a94c50703300846x605e66e0pbd8537a06436f6ee@mail.gmail.com>
Date: Fri, 30 Mar 2007 23:46:31 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, vapier.adi@gmail.com,
       jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <12871.1175267477@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175226172.15391.66.camel@roc-desktop>
	 <10785.1175247540@redhat.com>
	 <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>
	 <15938.1175253862@redhat.com>
	 <6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com>
	 <20070330155635.6a6c55d2@the-village.bc.nu>
	 <6d6a94c50703300738i7b9d3fcn341feb08dca8817d@mail.gmail.com>
	 <12871.1175267477@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, David Howells <dhowells@redhat.com> wrote:
> Aubrey Li <aubreylee@gmail.com> wrote:
>
> > Keep the same behave as MMU but with bad performance, or keep the same
> > performance as MMU but without the same behave, Which one is more
> > important?
>
> The thing to do is to pass a flag to mmap() to suppress the memset (as
> suggested).  This can then be used by the uClibc malloc() implementation and
> does not impact any application that does an anon mmap() expecting the memory
> returned to be zeroed.
>

As Mike mentioned, it implies breakage in POSIX behavior
and is specific to no-mmu only.

What kind of application does an anonymous mmap() expecting the memory
returned to be zeroed?

-Aubrey
