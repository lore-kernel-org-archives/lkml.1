Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXLTRkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXLTRkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbXLTRj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:39:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbXLTRj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:39:56 -0500
Message-ID: <476AA8E4.6090609@redhat.com>
Date: Thu, 20 Dec 2007 12:39:48 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 4/5]PCI: x86 MMCONFIG: introduce	pcibios_fix_bus_scan()]
References: <476A5F69.2030501@redhat.com> <20071220171914.GA5636@suse.de>
In-Reply-To: <20071220171914.GA5636@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Ah, sorry, I was thinking you were using dev_info(), which is what you
> should be using instead anyway :)
> 

I found it in include/linux/device.h

#define dev_info(dev, format, arg...)           \
         dev_printk(KERN_INFO , dev , format , ## arg)

The info I'm trying to print is before a dev or pci_dev struct
has been initialized for the device.

