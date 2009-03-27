Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZC0Paz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZC0Paz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbZC0Paq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:30:46 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:38314 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZC0Paq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:30:46 -0400
Date: Fri, 27 Mar 2009 16:30:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [MIPS] ip22: use a generic method for irq
	statistics
Message-ID: <20090327153021.GB24274@linux-mips.org>
References: <1238153951-18307-1-git-send-email-dmitri.vorobiev@movial.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238153951-18307-1-git-send-email-dmitri.vorobiev@movial.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 01:39:11PM +0200, Dmitri Vorobiev wrote:

> The structure 'struct kernel_stat' defines the 'irqs' array as its
> field only when CONFIG_GENERIC_HARDIRQS is not set. However, the ip22
> code makes use of this field unconditionally. As the result, the
> following build error is produced:
> 
>   CC      arch/mips/sgi-ip22/ip22-int.o
> arch/mips/sgi-ip22/ip22-int.c: In function 'indy_buserror_irq':
> arch/mips/sgi-ip22/ip22-int.c:158: error: 'struct kernel_stat' has no
> member named 'irqs'
> make[1]: *** [arch/mips/sgi-ip22/ip22-int.o] Error 1
> make: *** [arch/mips/sgi-ip22] Error 2
> 
> This patch fixes the build error by using the generic method for the irq
> statistics.

Applied, thanks!

  Ralf
