Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbXLTR4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbXLTR4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761989AbXLTRz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:55:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbXLTRz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:55:56 -0500
Date: Thu, 20 Dec 2007 09:52:36 -0800
From: Greg KH <gregkh@suse.de>
To: Tony Camuso <tcamuso@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 4/5]PCI: x86 MMCONFIG: introduce
	pcibios_fix_bus_scan()]
Message-ID: <20071220175236.GA24425@suse.de>
References: <476A5F69.2030501@redhat.com> <20071220171914.GA5636@suse.de> <476AA8E4.6090609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AA8E4.6090609@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 12:39:48PM -0500, Tony Camuso wrote:
> Greg KH wrote:
>> Ah, sorry, I was thinking you were using dev_info(), which is what you
>> should be using instead anyway :)
>
> I found it in include/linux/device.h
>
> #define dev_info(dev, format, arg...)           \
>         dev_printk(KERN_INFO , dev , format , ## arg)
>
> The info I'm trying to print is before a dev or pci_dev struct
> has been initialized for the device.

Ok, fair enough.

But you never answered my questions about _who_ would be responding to
those log messages about reporting things...

thanks,

greg k-h
