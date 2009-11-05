Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZKEOGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZKEOGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbZKEOGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:06:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:38958 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbZKEOGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:06:21 -0500
Subject: Re: [PATCH 5/8] spi_mpc8xxx: Fix uninitialized variable
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091012164922.GE4578@oksana.dev.rtsoft.ru>
Date: Thu, 5 Nov 2009 07:47:15 -0600
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F45D2413-4BA5-4127-A65E-CBF54956576A@kernel.crashing.org>
References: <20091012164841.GA32214@oksana.dev.rtsoft.ru> <20091012164922.GE4578@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2009, at 11:49 AM, Anton Vorontsov wrote:

> This patch fixes the following warning:
>
> CC      drivers/spi/spi_mpc8xxx.o
>  spi_mpc8xxx.c: In function 'of_mpc8xxx_spi_probe':
>  spi_mpc8xxx.c:681: warning: 'ret' may be used uninitialized in this  
> function
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> drivers/spi/spi_mpc8xxx.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)

applied to next

- k
