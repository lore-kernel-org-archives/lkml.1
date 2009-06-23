Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZFWLFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZFWLFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZFWLFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:05:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:38975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334AbZFWLFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:05:13 -0400
Subject: RE: [PATCH 1/2]Intel Moorestown NAND driver patch for mainline
From: David Woodhouse <dwmw2@infradead.org>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE313001A47964EB@pdsmsx503.ccr.corp.intel.com>
References: <20090606164455.GB27257@intel.com>
	 <20090606160413.08c254cf@lxorguk.ukuu.org.uk>
	 <38D9F46DFF92C54980D2F2C1E8EE313001A45F4F3C@pdsmsx503.ccr.corp.intel.com>
	 <1244458030.30939.216.camel@macbook.infradead.org>
	 <20090609003839.GB22766@suse.de>
	 <38D9F46DFF92C54980D2F2C1E8EE313001A47964EB@pdsmsx503.ccr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 12:05:11 +0100
Message-Id: <1245755111.25547.2036.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 18:59 +0800, Gao, Yunpeng wrote:
> Hi Greg, David and Alan,
> 
> I have discussed with the architect of Moorestown NAND driver today,
> and we agreed that the Moorestown NAND driver can not be ported to MTD
> subsystem.
> The reason is: 
> The NAND driver has to keep compatibility with Moorestown IA Firmware
> (which also operates on NAND device and is close source), and if the
> NAND driver is ported to MTD, the driver has to be changed much and
> thus will fail to keep the compatibility with Firmware.
> 
> As this is a standalone NAND driver, I think I can re-submit it to the
> block subsystem (maintained by Jens Axboe). Thus the NAND driver need
> not to change its architecture and can keep the compatibility with
> Firmware.
> 
> Also, it'll be better if the NAND driver can be in Greg's staging tree
> before the driver becomes 'good enough' and accepted by the block
> subsystem. Because some customers and partners want to get the latest
> NAND driver code from the kernel tree before the driver is accepted
> finally.
> 
> Does this suggestion make sense?

None whatsoever.

There is absolutely no reason why integrating properly with the MTD
subsystem would prevent you from retaining on-medium compatibility with
the firmware. We manage it for DiskOnChip devices, for example.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

