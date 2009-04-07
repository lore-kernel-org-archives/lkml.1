Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbZDGPI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbZDGPI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZDGPHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46759 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502AbZDGPHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:40 -0400
From: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "Paulraj, Sandeep" <s-paulraj@ti.com>
Date: Tue, 7 Apr 2009 10:07:16 -0500
Subject: RE: [PATCH] MTD-NAND: Changes to read_page APIs to support
 NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Thread-Topic: [PATCH] MTD-NAND: Changes to read_page APIs to support
 NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Thread-Index: Acm3DJO47XIQrYrxTciH3CafgfUNLAAhNAlw
Message-ID: <7A436F7769CA33409C6B44B358BFFF0CFFAA8FCA@dlee02.ent.ti.com>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com>
 <alpine.LFD.2.00.0904070102260.21577@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904070102260.21577@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Monday, April 06, 2009 7:08 PM
> To: Narnakaje, Snehaprabha
> Cc: linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org; davinci-
> linux-open-source@linux.davincidsp.com; Paulraj, Sandeep
> Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support
> NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
> 
> Sneha,
> 
> On Wed, 1 Apr 2009, nsnehaprabha@ti.com wrote:
> 
> Would you please care to CC the still caring but admittedly lazy and
> distracted maintainer on such patches ?

Who would that be?

Is the list below correct?

Steven J. Hill (sjhill@realitydiluted.com)
Thomas Gleixner (tglx@linuxtronix.de)
David Woodhouse (dwmw2@infradead.org)

> 
> > From: Sneha Narnakaje <nsnehaprabha@ti.com>
> >
> > The NAND controller on TI DaVinci DM355 supports NAND devices with large
> page size (2K and 4K), but the HW ECC is handled for every 512byte
> read/write chunks. The current HW_SYNDROME read_page/write_page APIs in
> the NAND core (nand_base) use the "infix OOB" scheme. The core APIs
> overwrite NAND manufacturer's bad block meta data, thus complicating the
> jobs of non-Linux NAND programmers (end equipment manufacturering). These
> APIs also imply ECC protection for the prepad bytes, causing nand
> raw_write operations to fail.
> 
> Please use proper line breaks. 523 characters do not fit into a
> terminal.

OK.

Thanks
Sneha
 
> 
> Thanks,
> 
> 	tglx
> 
> 

