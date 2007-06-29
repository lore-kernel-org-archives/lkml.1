Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbXF2UZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbXF2UZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXF2UZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:25:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55317 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbXF2UZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:25:07 -0400
Subject: Re: call request_irq before or after hardware initialization?
From: Arjan van de Ven <arjan@infradead.org>
To: Li Juen Hwang <lwen@ampex.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <46855F19.5080900@ampex.com>
References: <tkrat.78aa27c59575fdc3@s5r6.in-berlin.de>
	 <46855F19.5080900@ampex.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 29 Jun 2007 13:23:07 -0700
Message-Id: <1183148587.2642.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 12:35 -0700, Li Juen Hwang wrote:
> 
> Hi,
> 
>     Most 1394 drivers on Linux, ohci1394 for instance, calls 
> request_irq() before
>     initializing/enabling hardware chip. I'd like to reverse the order 
> so that driver
>     can exit the kernel without calling free_irq() if hardware failed. 
> Is that ok?
>     will it cause side effect? Thanks.

well you have to be able to handle interrupts the moment the hardware
will generate them... so the request_irq has to happen before that
point.


