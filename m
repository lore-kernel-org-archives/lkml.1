Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXLVQEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXLVQEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXLVQD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:03:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbXLVQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:03:55 -0500
Date: Sat, 22 Dec 2007 08:02:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       torvalds@linux-foundation.org
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071222080249.482fab0b@laptopd505.fenrus.org>
In-Reply-To: <20071222155436.GS29690@parisc-linux.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<476D1D16.5090703@garzik.org>
	<20071222064719.73fdd9a4@laptopd505.fenrus.org>
	<20071222155436.GS29690@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 08:54:37 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Dec 22, 2007 at 06:47:19AM -0800, Arjan van de Ven wrote:
> > Do you hate the name or the concept? I'm certainly open for a
> > better name.... 
> 
> I hate the concept.  We should just fall back to type1 accesses on
> mmconfig machines for all accesses below 64 bytes, as Ivan suggested.

I assume you meant 256 not 64;

even then.. it's technically not correct; you're not supposed to mix access types for the same device..
Just doing opt-in also allows us to do quirks (forbid access) as well.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
