Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbYJPT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbYJPT2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYJPT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:28:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47474 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbYJPT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:28:00 -0400
Date: Thu, 16 Oct 2008 15:27:55 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       apw@shadowen.org
Subject: Re: [PATCH] linux-next: Tree for October 16 - build failure at MAL
 support on powerpc
Message-ID: <20081016152755.2b95f80c@zod.rchland.ibm.com>
In-Reply-To: <20081016192320.GA7534@linux.vnet.ibm.com>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au>
	<20081016192320.GA7534@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 00:53:20 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Stephen,
> 
>         next-20081016 kernel build fails on powerpc, with build error
> 
> drivers/net/ibm_newemac/mal.c: In function 'mal_txeob':
> drivers/net/ibm_newemac/mal.c:284: error: implicit declaration of function 'mtdcri'
> drivers/net/ibm_newemac/mal.c:284: error: 'SDR0' undeclared (first use in this function)
> drivers/net/ibm_newemac/mal.c:284: error: (Each undeclared identifier is reported only once
> drivers/net/ibm_newemac/mal.c:284: error: for each function it appears in.)
> drivers/net/ibm_newemac/mal.c:285: error: implicit declaration of function 'mfdcri'
> drivers/net/ibm_newemac/mal.c: In function 'mal_rxeob':
> drivers/net/ibm_newemac/mal.c:302: error: 'SDR0' undeclared (first use in this function)
> make[3]: *** [drivers/net/ibm_newemac/mal.o] Error 1
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

I sent a more complete fix earlier today.

http://patchwork.ozlabs.org/patch/4708/

josh
