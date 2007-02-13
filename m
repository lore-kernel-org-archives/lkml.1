Return-Path: <linux-kernel-owner+w=401wt.eu-S1030599AbXBMAiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030599AbXBMAiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBMAiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:38:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:43373 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030607AbXBMAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:38:12 -0500
Date: Mon, 12 Feb 2007 16:33:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Joseph Cosby" <jo-cosby@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA Drive No Longer Recognized In New 2.6.20 Kernel
Message-Id: <20070212163337.3af55213.randy.dunlap@oracle.com>
In-Reply-To: <BAY120-F15C225BC4817C7D84BC43E83900@phx.gbl>
References: <jh6bEu1Gx0021e119@bay0-omc3-s26.bay0.hotmail.com>
	<BAY120-F15C225BC4817C7D84BC43E83900@phx.gbl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 17:30:38 -0700 Joseph Cosby wrote:

> Hi,
> Until recently I was using the 2.6.18 kernel. I have a SATA hard drive
> that was detected by the kernel, using the PIIX driver. But after
> updating to 2.6.20, the hard drive is no longer detected by the kernel.
> I used make oldconfig to create the 2.6.20 config file, and I noticed a
> new option CONFIG_ATA. I did not use this, because as I understand it is
> not necessary and is experimental. Do I need to use this or is there
> something else in the new kernel that needs to be enabled for this
> driver?

Yes, you need CONFIG_ATA for SATA after 2.6.18.

(prod) == production level code, not experimental (that only
applies to the PATA drivers)

> My 2.6.20 config file follows.
> The hard drive has vendor ID 8086 and device ID 27c0. It is listed in the
> modules.pcilist file of 2.6.18 but not 2.6.20.
> 
> If anybody can share any advice please CC me in response.
> 
> #
> # Serial ATA (prod) and Parallel ATA (experimental) drivers
> #
> # CONFIG_ATA is not set

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
