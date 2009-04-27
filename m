Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbZD0UuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbZD0UuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZD0UuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:50:07 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49534 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZD0UuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:50:06 -0400
Message-ID: <49F61A77.4060404@freescale.com>
Date: Mon, 27 Apr 2009 15:49:59 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090327 SeaMonkey/2.0a3
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: David Hawkins <dwh@ovro.caltech.edu>, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F60BF8.8040404@ovro.caltech.edu> <49F60FE1.90707@freescale.com> <20090427204752.GA22406@ld0162-tx32.am.freescale.net>
In-Reply-To: <20090427204752.GA22406@ld0162-tx32.am.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

> I thought the driver only used the bit if the device tree indicated it
> was an 83xx-era DMA controller?

I just wanted to make sure it didn't do anything weird.  It was the only
test I could think of that didn't involve PCI.

> That said, the bits are documented as specifically for PCI, so it would
> be surprising if it had any effect elsewhere.

Surely you wouldn't really be surprised by incorrect documentation of
our parts. :-)

-- 
Timur Tabi
Linux kernel developer at Freescale
