Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXCLNiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXCLNiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965616AbXCLNiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:38:22 -0400
Received: from mx10.go2.pl ([193.17.41.74]:52650 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965582AbXCLNiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:38:21 -0400
Date: Mon, 12 Mar 2007 14:42:31 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Miller <davem@davemloft.net>, amit2030@gmail.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [REVISED] net/ipv4/multipath_wrandom.c: check kmalloc() return value.
Message-ID: <20070312134230.GD3270@ff.dom.local>
References: <20070308.232908.92582631.davem@davemloft.net> <20070312115137.GA3270@ff.dom.local> <84144f020703120536l3967dc76o6a130edc79762350@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020703120536l3967dc76o6a130edc79762350@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 02:36:46PM +0200, Pekka Enberg wrote:
> On 3/12/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> >So, maybe it's less evil to check those NULLs where possible and add
> >some WARN_ONs here and there...
> 
> No, it's much better to oops rather than paper over a bug.
> 

I'm not sure I can understand your intentions - do you mean
always better? In my opinion oops is right only to avoid
some danger. And here is no danger - some routing info,
which is internal multipath_xxx data and can be handled
safely, will not go into its cache.

Jarek P.
