Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYFZDsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYFZDsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 23:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYFZDsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 23:48:42 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:46819 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYFZDsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 23:48:41 -0400
Date: Wed, 25 Jun 2008 23:48:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [patch 5/5] x86 PCI: use dev_printk when possible
In-reply-to: <20080613165304.842091464@ldl.fc.hp.com>
X-X-Sender: lenb@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <alpine.LFD.1.10.0806252345460.3279@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080613165209.507694130@ldl.fc.hp.com>
 <20080613165304.842091464@ldl.fc.hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess the 'INTA#; rather than 'INTA' syntax I'm not fond of appears in 
this x86 patch too.  I think if we don't really have anything useful 
to say about polarity, then we should not add an active low symbol.

thanks,
-Len

-       printk(KERN_INFO "PCI: %s IRQ %d for device %s\n", msg, irq, 
pci_name(dev));
+       dev_info(&dev->dev, "%s PCI INT%c# -> IRQ %d\n", msg, 'A' + pin, 
irq);


