Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZDFXIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZDFXIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZDFXIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:08:15 -0400
Received: from www.tglx.de ([62.245.132.106]:44881 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZDFXIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:08:14 -0400
Date: Tue, 7 Apr 2009 01:07:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sneha Narnakaje <nsnehaprabha@ti.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Sandeep Paulraj <s-paulraj@ti.com>
Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support
 NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
In-Reply-To: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com>
Message-ID: <alpine.LFD.2.00.0904070102260.21577@localhost.localdomain>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sneha,

On Wed, 1 Apr 2009, nsnehaprabha@ti.com wrote:

Would you please care to CC the still caring but admittedly lazy and
distracted maintainer on such patches ?

> From: Sneha Narnakaje <nsnehaprabha@ti.com>
> 
> The NAND controller on TI DaVinci DM355 supports NAND devices with large page size (2K and 4K), but the HW ECC is handled for every 512byte read/write chunks. The current HW_SYNDROME read_page/write_page APIs in the NAND core (nand_base) use the "infix OOB" scheme. The core APIs overwrite NAND manufacturer's bad block meta data, thus complicating the jobs of non-Linux NAND programmers (end equipment manufacturering). These APIs also imply ECC protection for the prepad bytes, causing nand raw_write operations to fail.

Please use proper line breaks. 523 characters do not fit into a
terminal.

Thanks,

	tglx


