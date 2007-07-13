Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXGMJ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXGMJ4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXGMJ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:56:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXGMJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:56:23 -0400
Date: Fri, 13 Jul 2007 10:56:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Make asm-generic/ioctl.h more generic using conditionals.
Message-ID: <20070713095620.GD16304@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0707100629070.11966@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707100629070.11966@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 06:33:26AM -0400, Robert P. J. Day wrote:
> + * Let any architecture override either of the following before
> + * including this file.
> + */
> +
> +#ifndef _IOC_SIZEBITS
> +# define _IOC_SIZEBITS	14
> +#endif
> +
> +#ifndef _IOC_DIRBITS
> +# define _IOC_DIRBITS	2
> +#endif

I don't think this is usefull.  It just makes it less obvious to find
this definition which must not change ever due to abi reasons anyway.

