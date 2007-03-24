Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXCXPij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXCXPij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbXCXPij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:38:39 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42438 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbXCXPii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:38:38 -0400
Date: Sat, 24 Mar 2007 07:38:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-24-00-14.tar.gz uploaded
Message-Id: <20070324073833.af78ddb4.akpm@linux-foundation.org>
In-Reply-To: <46050D05.1000205@googlemail.com>
References: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>
	<46050D05.1000205@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 12:35:33 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> 
> akpm@linux-foundation.org napisał(a):
> > The mm snapshot broken-out-2007-03-24-00-14.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-24-00-14.tar.gz
> > 
> > It contains the following patches against 2.6.21-rc4:
> 
> Bryan, your patch (blackfin-arch-2.6.21-rc4-mm1-update.patch) doesn't apply
> clean. I've got a lot of "1 out of 1 hunk FAILED -- rejects in file".
> 
> Applying patch patches/blackfin-arch-2.6.21-rc4-mm1-update.patch
> patching file arch/blackfin/Kconfig
> patching file arch/blackfin/Makefile
> patching file arch/blackfin/kernel/Makefile
> patching file arch/blackfin/kernel/asm-offsets.c
> Hunk #1 FAILED at 6.
> 1 out of 1 hunk FAILED -- rejects in file arch/blackfin/kernel/asm-offsets.c
> patching file arch/blackfin/kernel/bfin_dma_5xx.c

That's because it contains CVS control strings.  I fixed it locally,
but please don't add CVS control strings to the kernel.
