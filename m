Return-Path: <linux-kernel-owner+w=401wt.eu-S1767227AbXDTUaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767227AbXDTUaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767236AbXDTUaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:30:16 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:4479 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767227AbXDTUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:30:15 -0400
Date: Sat, 21 Apr 2007 00:30:20 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PCI bridge range sizing bug
Message-ID: <20070421003020.A21503@jurassic.park.msu.ru>
References: <1175812632.17147.12.camel@localhost.localdomain> <alpine.LFD.0.98.0704191702200.9964@woody.linux-foundation.org> <20070420132352.A19232@jurassic.park.msu.ru> <200704200932.52181.jesse.barnes@intel.com> <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org>; from torvalds@linux-foundation.org on Fri, Apr 20, 2007 at 11:28:42AM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 11:28:42AM -0700, Linus Torvalds wrote:
> Actually, I would suggest we not do it automatically (because the need for 
> it is just so low, and the downsides are potentially huge - there are just 
> too many resources that are "hidden" from us through ACPI tricks and 
> having hardware that doesn't actually expose their PCI resources fully 
> through the normal PCI resource setup).

Definitely. I was intending to enable that *only* with some boot option.

> Ivan, want to add some way to force that allocation (something like 
> "pci=assign-bus-resources")

Yes, hopefully I'll get something in a next couple of days.

Ivan.
