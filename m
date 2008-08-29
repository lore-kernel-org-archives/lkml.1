Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYH2Oxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYH2Oxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYH2Owk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:52:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:35172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYH2Owj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:52:39 -0400
Date: Fri, 29 Aug 2008 05:50:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [RFC] export irq_set/get_affinity() for multiqueue network
 drivers
Message-ID: <20080829055023.07966b4a@infradead.org>
In-Reply-To: <48B708E1.4070001@inria.fr>
References: <48B708E1.4070001@inria.fr>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 22:21:53 +0200
Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Hello,
> 
> Is there any way to setup IRQ masks from within a driver? myri10ge
> currently relies on an external script (writing in
> /proc/irq/*/smp_affinity) to bind each queue/MSI-X to a different
> processor. By default, Linux will either:
> * round-robin the interrupts (killing the benefit of DCA for instance)
> * put all IRQs on the same CPU (killing much of th

* do the right thing with the userspace irq balancer

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
