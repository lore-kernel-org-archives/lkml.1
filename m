Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbXIIORk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbXIIORk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 10:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXIIORd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 10:17:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbXIIORc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 10:17:32 -0400
Date: Sun, 9 Sep 2007 16:17:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
Message-ID: <20070909141730.GB25798@one.firstfloor.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E3FE6B.7010209@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, I suspect Andi's x86_64-mm-cpa-clflush.patch or something like that. It
> loops in flush_kernel_map in list_for_each_entry on the first CPU. The a->l list
> is somehow corrupted I guess.

Does it still happen with the latest version 

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/cpa-clflush

?

(you might need to replace the other cpa-* patches too because
they depend on each other) 

-Andi
