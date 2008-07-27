Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYG0TZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYG0TZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbYG0TZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:25:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560AbYG0TZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:25:03 -0400
Date: Sun, 27 Jul 2008 12:24:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] powerpc/ibmveth: fix multiple errors with
 dma_mapping_error conversion
Message-Id: <20080727122414.cac4e336.akpm@linux-foundation.org>
In-Reply-To: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
References: <20080728021424.40cf66bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 02:14:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> The addition of an argument to dma_mapping_error() in commit
> 8d8bb39b9eba32dd70e87fd5ad5c5dd4ba118e06 "dma-mapping: add the device
> argument to dma_mapping_error()" left a bit of fallout:

Yeah, sorry, that patch was a horror - I fixed it perhaps ten times.  I
think people were madly adding new dma_mapping_error() calls while we
were trying to maintain it as well.

It should have been dome as a two-stage conversion.
