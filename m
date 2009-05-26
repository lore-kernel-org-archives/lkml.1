Return-Path: <linux-kernel-owner+w=401wt.eu-S1751781AbZEZKZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbZEZKZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbZEZKZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:25:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44209 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZEZKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:25:10 -0400
Date: Tue, 26 May 2009 06:25:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: rtc-linux@googlegroups.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] drivers/char/rtc: disable legacy RTC driver on
	Blackfin systems
Message-ID: <20090526102502.GA24737@infradead.org>
References: <1243332633-15258-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243332633-15258-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 06:10:33AM -0400, Mike Frysinger wrote:
>  	tristate "Enhanced Real Time Clock Support (legacy PC RTC driver)"
>  	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
> -			&& !ARM && !SUPERH && !S390 && !AVR32
> +			&& !ARM && !SUPERH && !S390 && !AVR32 && !BLACKFIN

Maybe it's better to have a positive dependency for those that actually
support it these days?  Based on the above list that would be:

	depends on ALPHA || CRIS || H8300 || M32R || MICROBLAZE ||
		   MIPS || MN10300 || SH || X86 || XTENSA

and I would not be surprised if some of the above don't actually support
it either..
