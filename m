Return-Path: <linux-kernel-owner+w=401wt.eu-S1750702AbXBKPc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750702AbXBKPc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXBKPc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:32:58 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:46422 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXBKPc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:32:57 -0500
Date: Sun, 11 Feb 2007 16:31:44 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
Message-ID: <20070211153144.GA11547@osiris.ibm.com>
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com> <20070211063431.GS10050@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211063431.GS10050@ftp.linux.org.uk>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My current version:
> 
> From 97f115834b5ebef4f04e0f18aaa10f78f43733a0 Mon Sep 17 00:00:00 2001
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Sat, 10 Feb 2007 23:41:09 -0500
> Subject: [PATCH] sort the devres mess out
> 
> Split the implementation-agnostic stuff in separate files.
> Make sure that targets using non-default request_irq() pull kernel/irq/devres.o
> Mark targets that have no ioport_map() and friends, protect the ioport-related
> Parts of lib/devres.o with corresponding ifdef (BTW, we need it in driver
> dependencies in quite a few of cases, so that symbol was needed anyway).
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Works fine for me. If this one is applied too s390 works again:
http://lkml.org/lkml/2007/2/10/41

Thanks!
