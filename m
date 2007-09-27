Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbXI0AlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbXI0AlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXI0Ak4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:40:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:58282 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbXI0Akz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:40:55 -0400
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46FAE4CE.10801@shaw.ca>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
	 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
	 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no>
	 <fa.0Edi0qLTdvqVnuoDAebaTVz1jEM@ifi.uio.no>
	 <fa.sq+NimBnzGB2syLmvcIGOvDkixI@ifi.uio.no>
	 <fa.G9DPndNUxuPi5LrUTOL4uPFshnc@ifi.uio.no>  <46FAE4CE.10801@shaw.ca>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 10:40:33 +1000
Message-Id: <1190853633.11034.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> How is this a change in behavior as far as this device is concerned? If 
> we are doing BAR sizing and moving the base address around, it's going 
> to cause problems if you try to access the device during this time 
> whether we disable decode or not.

True. The window is smaller tho if the upper bridge decode hasn't been
disabled. I suppose I'll have to find a way to "pin" those devices and
generate the BAR info from the firmware data.

Ben.


