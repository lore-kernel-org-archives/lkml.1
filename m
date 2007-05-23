Return-Path: <linux-kernel-owner+w=401wt.eu-S934637AbXEWVK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbXEWVK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbXEWVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:10:08 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:51408 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761011AbXEWVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:10:06 -0400
X-IronPort-AV: i="4.14,571,1170662400"; 
   d="scan'208"; a="156770936:sNHT175942881"
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
X-Message-Flag: Warning: May contain useful information
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>
	<4654AB40.6060208@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 23 May 2007 14:10:03 -0700
In-Reply-To: <4654AB40.6060208@gmail.com> (Manu Abraham's message of "Thu, 24 May 2007 00:59:44 +0400")
Message-ID: <adaejl79rh0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2007 21:10:04.0109 (UTC) FILETIME=[BB88BFD0:01C79D7E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Uncompressing Linux .. Ok, booting the kernel.
>> BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)
>> PCI: Failed to allocate mem resource #6:20000@30000000 for 0000:01:00.0

This message is about device 01:00.0 as it says (your nvidia video
card based on later lspci output).

 > The device is a new DTV bridge from NXP (SAA7162E) with a PCIe interface.
 > 
 > 06:00.0 Multimedia controller: Philips Semiconductors Unknown device
 > 7162 (rev 01)
 >         Subsystem: Twinhan Technology Co. Ltd Unknown device 0027

This is device 06:00.0, so it's not related to that earlier message at
all.  You didn't say what problem you're having with your driver for
this device... but all standard PCI stuff should work fine for PCIe
devices -- the normal PCI driver stuff is all you should need for
everything but exotic cases.

 - R.
