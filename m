Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYJHIl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYJHIl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYJHIlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:41:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYJHIlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:41:18 -0400
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, avorontsov@ru.mvista.com,
       Matt Sealey <matt@genesi-usa.com>, Jeff Garzik <jgarzik@pobox.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Li Yang <leoli@freescale.com>,
       Wang Jian <lark@linux.net.cn>
In-Reply-To: <20081007103723.0224671e@lxorguk.ukuu.org.uk>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	 <48EA77EF.6080502@genesi-usa.com>
	 <20081006213209.GA13072@oksana.dev.rtsoft.ru> <48EABBD3.1010401@kernel.org>
	 <20081007103723.0224671e@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 09:40:54 +0100
Message-Id: <1223455254.3145.143.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 10:37 +0100, Alan Cox wrote:
> Zero means no IRQ. Any platform with bits of code left over exposing IRQ
> 0 is already not supported by lots of driver code including libata.

...and must implement some kind of interrupt remapping crap just to work
around this bogus design decision.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

