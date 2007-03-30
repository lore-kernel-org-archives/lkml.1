Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbXC3RJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbXC3RJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXC3RJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:09:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37816 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257AbXC3RJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:09:51 -0400
Date: Fri, 30 Mar 2007 19:13:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: "David Howells" <dhowells@redhat.com>, vapier.adi@gmail.com,
       jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding
 UNINITIALIZE flag
Message-ID: <20070330191323.13f39605@the-village.bc.nu>
In-Reply-To: <6d6a94c50703300738i7b9d3fcn341feb08dca8817d@mail.gmail.com>
References: <1175226172.15391.66.camel@roc-desktop>
	<10785.1175247540@redhat.com>
	<6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>
	<15938.1175253862@redhat.com>
	<6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com>
	<20070330155635.6a6c55d2@the-village.bc.nu>
	<6d6a94c50703300738i7b9d3fcn341feb08dca8817d@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Summary is, when I run the app "time test",
> 
> on x86:
> real    0m0.066s
> user    0m0.008s
> sys     0m0.058s
> 
> on Blackfin:
> real    3m 37.69s
> user    0m 0.04s
> sys     3m 37.58s

What would be relevant would be Blackfin with clearing and blackfin
without

> ---------------------------------------------------------------
> So now the question is,
> Keep the same behave as MMU but with bad performance, or keep the same
> performance as MMU but without the same behave, Which one is more
> important?

Behaviour.

You can implement a /dev/pages that is a copy of /dev/zero in tiny
amounts of code and use that for the specific problem cases.

Alan
