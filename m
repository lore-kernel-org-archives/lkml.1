Return-Path: <linux-kernel-owner+w=401wt.eu-S1765502AbXJRWQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765502AbXJRWQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbXJRWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:16:23 -0400
Received: from www.tglx.de ([62.245.132.106]:40701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbXJRWQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:16:22 -0400
Date: Fri, 19 Oct 2007 00:15:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org,
       Paul Sokolovsky <pmiscml@gmail.com>, Ben Dooks <ben@trinity.fluff.org>
Subject: Re: [RFC] [PATCH -mm] ASIC3 driver
In-Reply-To: <20071018150544.6852d5c9.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0710190013420.22770@localhost.localdomain>
References: <20071018091239.GA11360@caravaggio> <20071018150544.6852d5c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, Andrew Morton wrote:
> > +
> > +#include <linux/module.h>
> > +#include <linux/version.h>
> > +#include <linux/irq.h>
> 
> Please see the large comment at the top of linux/irq.h.  I believe this
> driver will fial to compile on at least arm.
> 
> We really should fix this.

drivers are fine with: #include <linux/interrupt.h>

If they need linux/irq.h, then they do probably something really
nasty.

   	tglx
