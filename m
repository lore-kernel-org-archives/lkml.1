Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYIQVnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYIQVnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYIQVnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:43:09 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:49002 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbYIQVnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:43:08 -0400
Date: Wed, 17 Sep 2008 15:43:06 -0600
From: Alex Chiang <achiang@hp.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bjorn.helgaas@hp.com
Subject: Re: [PATCH 3/5] pci: using pci_printk
Message-ID: <20080917214305.GA2222@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com> <1221555174-30060-3-git-send-email-yhlu.kernel@gmail.com> <20080916102052.GD21012@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916102052.GD21012@x200.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan <adobriyan@gmail.com>:
> On Tue, Sep 16, 2008 at 01:52:52AM -0700, Yinghai Lu wrote:
> > --- linux-2.6.orig/drivers/pci/probe.c
> > +++ linux-2.6/drivers/pci/probe.c
> > @@ -304,7 +304,7 @@ static int __pci_read_base(struct pci_de
> 
> > -			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> > +			pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
> 				   ^^^^^^^^^^^^^^^^^^^^^^^^^^
> Brilliant, simply brilliant!

Yeah, that's ugly.

> Printk haters club is definitely creative, no questions.

Bjorn might have some useful advice here.

Also, didn't we recently get all the PCI printk output to
resemble what lspci shows us?

/ac

