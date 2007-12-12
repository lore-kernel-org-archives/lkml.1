Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXLLPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXLLPP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXLLPPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:15:51 -0500
Received: from www.tglx.de ([62.245.132.106]:51937 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbXLLPPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:15:50 -0500
Date: Wed, 12 Dec 2007 16:14:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Kevin Hilman <khilman@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Generic IRQ: Add unlocked version of set_irq_handler()
In-Reply-To: <20071212102437.GI24246@elte.hu>
Message-ID: <alpine.LFD.0.99999.0712121614001.3257@localhost.localdomain>
References: <1197413651-23076-1-git-send-email-khilman@mvista.com> <20071212102437.GI24246@elte.hu>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007, Ingo Molnar wrote:

> 
> * Kevin Hilman <khilman@mvista.com> wrote:
> 
> > Add unlocked version for use by irq_chip.set_type handlers which may 
> > wish to change handler to level or edge handler when IRQ type is 
> > changed.
> > 
> > The normal set_irq_handler() call cannot be used because it tries to 
> > take irq_desc.lock which is already held when the irq_chip.set_type 
> > hook is called.
> 
> looks fine to me. Thomas?

Acked-by: Thomas Gleixner <tglx@linutronix.de>
