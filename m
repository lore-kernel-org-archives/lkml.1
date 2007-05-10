Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbXEJPxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbXEJPxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXEJPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:53:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbXEJPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:52:59 -0400
Date: Thu, 10 May 2007 16:52:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <ak@suse.de>, Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow compat_ioctl.c to compile without CONFIG_NET
Message-ID: <20070510155257.GA27834@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Andi Kleen <ak@suse.de>,
	Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20070510094110.GA16051@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510094110.GA16051@verge.net.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 06:41:20PM +0900, Simon Horman wrote:
> A small regression appears to have been introduced in the recent patch
> "cleanup compat ioctl handling", which was included in Linus' tree after
> 2.6.20.
> 
> siocdevprivate_ioctl() is no longer defined if CONFIG_NET is undefined,
> whereas previously it was a dummy function in this case.
> 
> This causes compilation with CONFIG_COMPAT but without CONFIG_NET to fail.
> 
> fs/compat_ioctl.c: In function `compat_sys_ioctl':
> fs/compat_ioctl.c:3571: warning: implicit declaration of function `siocdevprivate_ioctl'
> 
> Cc: Christoph Hellwig <hch@lst.de>
> From: Simon Horman <horms@verge.net.au>

Ok.
