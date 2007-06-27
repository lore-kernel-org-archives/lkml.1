Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXF0Skc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXF0Skc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXF0SkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:40:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57829 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbXF0SkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:40:23 -0400
Subject: Re: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
From: Arjan van de Ven <arjan@infradead.org>
To: Casey Leedom <casey_leedom@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070627181208.98426.qmail@web30504.mail.mud.yahoo.com>
References: <20070627181208.98426.qmail@web30504.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 27 Jun 2007 11:39:06 -0700
Message-Id: <1182969547.2718.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 11:12 -0700, Casey Leedom wrote:
> Hello,
> 
>   I'm working on a driver that does a get_user_pages() for a DMA write.  We
> have a timeout on the DMA completion where we mark the pages as COW and return
> to the application so it can potentially generate more data in order to
> increase throughput, etc.  The problem is that when we traverse the
> PGT/PUD/PMD/PTE hierarchy to mark the pages, we sometime fault out when the PUD
> covering [0x80000000, 0xc0000000) comes out as zero when that entire region is
> covered by a single large malloc()'ed buffer.  

you forgot to attach your source code or provide a URL to it.....


