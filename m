Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYJMXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYJMXdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbYJMXdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:33:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:60302 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbYJMXdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:33:05 -0400
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Tejun Heo <tj@kernel.org>
Cc: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Li Yang <leoli@freescale.com>, Jeff Garzik <jgarzik@pobox.com>,
       Wang Jian <lark@linux.net.cn>
In-Reply-To: <48F2F138.6020103@kernel.org>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	 <48F2F138.6020103@kernel.org>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 10:27:14 +1100
Message-Id: <1223940434.8157.283.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-13 at 15:56 +0900, Tejun Heo wrote:
> Anton Vorontsov wrote:
> > When no irq specified the pata_of_platform fills the irq_res with -1,
> > which is wrong to do for two reasons:
> > 
> > 1. By definition, 'no irq' should be IRQ 0, not some negative integer;
> > 2. pata_platform checks for irq_res.start > 0, but since irq_res.start
> >    is unsigned type, the check will be true for `-1'.
> > 
> > Reported-by: Steven A. Falco <sfalco@harris.com>
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> applied to #tj-upstream (will soon be sent upstream)

Hrm... I applied it to powerpc.git too :-) Hopefully the merge will sort
it out !

Cheers,
Ben.


