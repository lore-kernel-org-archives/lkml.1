Return-Path: <linux-kernel-owner+w=401wt.eu-S935912AbYCSWav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935912AbYCSWav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935969AbYCSVET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:04:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51398 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763820AbYCSVEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:04:16 -0400
Date: Wed, 19 Mar 2008 01:45:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080319054545.GA18834@infradead.org>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 10:31:19AM +0100, Heiko Carstens wrote:
> Hi Thomas, Ingo,
> 
> I'm converting s390 from s390's NO_IDLE_HZ to GENERIC_CLOCKEVENTS and
> therefore to the generic NO_HZ implementation.
> One of the problems that need a patch for this is kernel/time/tick-common.c
> which relies on the irq stuff present in include/linux/irq.h.
> In particular s390 doesn't have something like irq_set_affinity which
> causes this build error:

Generic code must never use linux/irq.h - it's more like asm-generic
file predating asm-generic.

