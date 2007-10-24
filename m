Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXJWQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXJWQxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXJWQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:53:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:33795 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbXJWQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=nAPAmSGlF2UxwNGwHn+mMoktqL3vMocAIackROvVGlW4NHdxcjYu4VfcWtAVqL4g4srSCxbUW9X8LplTqivN7ioOVvhGKFaIqEjfylpAOXUCqxiziGYiq3sfQ76mPNGzSt8sTlfgtomLxNeS4yAoxaGuwdjhoTUnHoEjj4Usq/g=
Date: Tue, 23 Oct 2007 18:53:05 -0700
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
       linuxsh <linuxsh-dev@lists.sourceforge.net>
Subject: [SUPERH] dma-mapping.h structure has no member named page
Message-Id: <20071023185305.4fd9a084.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Got this after syncing my tree with linux-2.6.git.

In file included from include/linux/dma-mapping.h:52,
                 from include/linux/dmaengine.h:29,
                 from include/linux/skbuff.h:29,
                 from include/linux/netlink.h:155,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from init/main.c:46:
include/asm/dma-mapping.h: In function `dma_map_sg':
include/asm/dma-mapping.h:88: error: structure has no member named `page'
include/asm/dma-mapping.h:91: error: structure has no member named `page'
include/asm/dma-mapping.h: In function `dma_sync_sg':
include/asm/dma-mapping.h:141: error: structure has no member named `page'
include/asm/dma-mapping.h:144: error: structure has no member named `page'
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2
