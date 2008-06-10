Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbYFJWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbYFJWCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYFJWCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:02:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45429 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYFJWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:02:42 -0400
Date: Wed, 11 Jun 2008 00:02:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
In-Reply-To: <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com>
Message-ID: <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com> <20080609125530.GF30405@parisc-linux.org> <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-06-10 10:49, Maxim Shchetynin wrote:
>
>What do you think about the following - shorter description and a better place for it (moved to "Pseudo filesystems"):
>
>--- linux-2.6.26-rc5/fs/Kconfig 2008-06-05 05:10:44.000000000 +0200
>+++ linux-2.6.26-rc5-azfs/fs/Kconfig    2008-06-10 10:43:24.326686538 +0200
>@@ -1017,6 +1017,19 @@
> config HUGETLB_PAGE
>        def_bool HUGETLBFS
>
>+config AZ_FS
>+       tristate "AZFS filesystem support"

This is slightly redundant, it should probably be
	tristate "AZ filesystem support"

>+       help
>+         azfs is a file system for I/O attached memory backing. It requires
>+         a block device with direct_access capability, e.g. axonram.

(a) What is axonram?
(b) why is axonram direct_access, and my other devices (including
standard PC RAM) not?

>+         Mounting such device with azfs gives memory mapped access to the
>+         underlying memory to user space.

Can't I just mmap(/dev/theblockdevice), why would I need to go through 
azfs?


