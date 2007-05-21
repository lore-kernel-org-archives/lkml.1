Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbXEUXSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbXEUXSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXEUXSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:18:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:64306 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998AbXEUXR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,563,1170662400"; 
   d="scan'208";a="230566428"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
Date: Mon, 21 May 2007 16:17:50 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
References: <200705212305.l4LN5irk008924@turbo.physics.adelaide.edu.au>
In-Reply-To: <200705212305.l4LN5irk008924@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211617.50642.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007 4:05 pm Jonathan Woithe wrote:
> 02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device
> 6101 (rev b1) (prog-if 8f [Master SecP SecO PriP PriO]) Subsystem:
> Marvell Technology Group Ltd. Unknown device 6101 Flags: bus master,
> fast devsel, latency 0, IRQ 10
> 	I/O ports at 1018 [size=8]
> 	I/O ports at 1024 [size=4]
> 	I/O ports at 1010 [size=8]
> 	I/O ports at 1020 [size=4]
> 	I/O ports at 1000 [size=16]
> 	Memory at 90100000 (32-bit, non-prefetchable) [size=512]
> 	Capabilities: [48] Power Management version 2
> 	Capabilities: [50] Message Signalled Interrupts: 64bit- Queue=0/0
> Enable- Capabilities: [e0] Express Legacy Endpoint IRQ 0

Looks like you've got Marvell IDE for your PATA stuff (my board is the 
same).  Try the latest Marvell driver, it seems to drive my machine ok.  
For older kernels, I think you can pass 'all-generic-ide' on the boot 
line to get the old IDE layer to drive the device.

Jesse
