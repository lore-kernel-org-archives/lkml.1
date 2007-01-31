Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXAaFL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXAaFL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932860AbXAaFL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:11:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855AbXAaFL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:11:58 -0500
Date: Tue, 30 Jan 2007 21:11:53 -0800
From: Andrew Morton <akpm@osdl.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Reducing warning output from pci_get_subsys()
Message-Id: <20070130211153.4ca1aaa7.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701302251520.5644@localhost.localdomain>
References: <Pine.LNX.4.64.0701302251520.5644@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 22:55:38 -0600 (CST)
Kumar Gala <galak@kernel.crashing.org> wrote:

> Greg,
> 
> There was some code added to warn if pci_get_subsys() is called and the 
> pci_devices is empty.
> 
> I'm wondering if there is some point at which we know its ok for the 
> pci_devices list be empty if there are no devices on the bus so we can 
> stop printing the message.
> 
> On an embedded PPC reference system I see this message 6 times when I've 
> got no cards in the PCI slots.
> 

I'd suggest we just remove the warning.  Also the one in pci_find_subsys().

I let them go through because I was curious to know what would cause it to
trigger - it might be an indication of other bugs.  But nothing very
interesting happened and they're of no use.

