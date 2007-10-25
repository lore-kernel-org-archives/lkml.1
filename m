Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbXJYEGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbXJYEGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXJYEF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:05:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbXJYEF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:05:56 -0400
Date: Wed, 24 Oct 2007 21:05:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [patch 2/2] Use BOOTMEM_EXCLUSIVE for kdump
Message-Id: <20071024210533.b919dba3.akpm@linux-foundation.org>
In-Reply-To: <20071024163734.204144819@strauss.suse.de>
References: <20071024163733.366829630@strauss.suse.de>
	<20071024163734.204144819@strauss.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:37:35 +0200 Bernhard Walle <bwalle@suse.de> wrote:

> This patch uses the BOOTMEM_EXCLUSIVE, introduced in the previous patch,
> to avoid conflicts while reserving the memory for the kdump carpture kernel
> (crashkernel=).
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  arch/sh/kernel/setup.c     |   29 ++++++++++++++++++-----------
>  arch/x86/kernel/setup_32.c |   28 ++++++++++++++++++----------
>  arch/x86/kernel/setup_64.c |   35 +++++++++++++++++++++--------------

ia64 and powerpc support crash dump too?
