Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYGWNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYGWNCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYGWNCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:02:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYGWNCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:02:41 -0400
Date: Wed, 23 Jul 2008 15:02:22 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Vrabel <david.vrabel@csr.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080723150222.4de1775c@brian.englab.brq.redhat.com>
In-Reply-To: <200807221052.26879.jbarnes@virtuousgeek.org>
References: <4860D09D.4060801@csr.com>
	<48807166.9010006@csr.com>
	<20080722155629.1160635e@brian.englab.brq.redhat.com>
	<200807221052.26879.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 10:52:26 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tuesday, July 22, 2008 6:56 am Michal Schmidt wrote:
> > This breaks the setting of SMP affinity for MSI interrupts :-(
> > With the patch, writes to /proc/irq/<n>/smp_affinity are ignored
> > for an MSI interrupt.
> 
> It should only break it for devices that don't provide a mask bit.

Yes, smp_affinity works for devices with a mask bit.

> But given that we can't really mask generically on those devices,
> maybe that's ok given that it fixes the other problems mentioned in
> this thread...

Does it mean there is no way IRQ migration could work reliably for
devices without a mask bit?

Michal
