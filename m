Return-Path: <linux-kernel-owner+w=401wt.eu-S973322AbXHMNsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973322AbXHMNsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936888AbXHMKTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:19:49 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:37101 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936883AbXHMKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:19:47 -0400
Date: Mon, 13 Aug 2007 11:19:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Patrick Gefre <pfg@sgi.com>
Subject: Re: [PATCH] [261/2many] MAINTAINERS - IOC3 DRIVER
Message-ID: <20070813101941.GA6462@linux-mips.org>
References: <46bffa6e.aluJMNuvp11tc2XU%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffa6e.aluJMNuvp11tc2XU%joe@perches.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:30:06PM -0700, joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6263958..207331c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2501,6 +2501,8 @@ P:	Ralf Baechle
>  M:	ralf@linux-mips.org
>  L:	linux-mips@linux-mips.org
>  S:	Maintained
> +F:	drivers/net/ioc3-eth.c
> +F:	drivers/serial/ioc3_serial.c

Although for the same multifunction device at this stage the IOC3 ethernet
and ioc3_serial are totally separate, so I suggest to add a separate
MAINTAINERS entry for ioc3_serial with Patrick Gefre <pfg@sgi.com> as the
maintainer.

  Ralf
