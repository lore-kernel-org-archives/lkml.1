Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbYD3Rce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbYD3Rce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbYD3RcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:32:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758195AbYD3RcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:32:20 -0400
Date: Wed, 30 Apr 2008 10:31:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: greg@kroah.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, Emilian.Medve@Freescale.com, htejun@gmail.com
Subject: Re: [PATCH v2] [POWERPC] devres: Add devm_ioremap_flags()
Message-Id: <20080430103132.c110a84c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 11:08:51 -0500 (CDT)
Kumar Gala <galak@kernel.crashing.org> wrote:

> From: Emil Medve <Emilian.Medve@Freescale.com>
> 
> We provide an ioremap_flags so provide a coresphonding devm_ioremap_flags.
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Forgot to commit the actual implemtation in arch/powerpc/lib/devres.c
> 
> Which tree should this go through, powerpc.git?

I'd say so, yes.

> arch/powerpc/lib/Makefile |    1 +
> arch/powerpc/lib/devres.c |   33 +++++++++++++++++++++++++++++++++
> include/asm-powerpc/io.h  |    8 +++++++-
> include/linux/io.h        |    1 +
> lib/devres.c              |    2 +-
>
