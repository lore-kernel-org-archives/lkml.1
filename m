Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbYG3VSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbYG3VSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbYG3VSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:18:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33670 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbYG3VSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:18:24 -0400
Message-ID: <4890DA8E.5000502@garzik.org>
Date: Wed, 30 Jul 2008 17:18:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] powerpc/ibmveth: fix multiple errors with dma_mapping_error
 conversion
References: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
In-Reply-To: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> The addition of an argument to dma_mapping_error() in commit
> 8d8bb39b9eba32dd70e87fd5ad5c5dd4ba118e06 "dma-mapping: add the device
> argument to dma_mapping_error()" left a bit of fallout:
> 
> drivers/net/ibmveth.c:263: error: too few arguments to function 'dma_mapping_error'
> drivers/net/ibmveth.c:264: error: expected ')' before 'goto'
> drivers/net/ibmveth.c:284: error: expected expression before '}' token
> drivers/net/ibmveth.c:297: error: too few arguments to function 'dma_mapping_error'
> drivers/net/ibmveth.c:298: error: expected ')' before 'dma_unmap_single'
> drivers/net/ibmveth.c:306: error: expected expression before '}' token
> drivers/net/ibmveth.c:491: error: too few arguments to function 'dma_mapping_error'
> drivers/net/ibmveth.c:927: error: too few arguments to function 'dma_mapping_error'
> drivers/net/ibmveth.c:927: error: expected ')' before '{' token
> drivers/net/ibmveth.c:974: error: expected expression before '}' token
> drivers/net/ibmveth.c:914: error: label 'out' used but not defined m
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ibmveth.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> Compiler tested for ppc64_defconfig.

applied


