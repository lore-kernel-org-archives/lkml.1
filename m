Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0BOSS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:18:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab0BOSSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:18:25 -0500
Date: Mon, 15 Feb 2010 13:18:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC]: new LSI MegaRAID driver implementation
Message-ID: <20100215181823.GA25776@infradead.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 10:09:23AM -0700, Mukker, Atul wrote:
> We are anticipating about 70-80% of the current driver code to be changed. These changes would not be functional in nature though. The current functionality would be re-aligned in supporting functions. A parallel stream of functions would be created to support new HBAs.
> 
> We are not anticipating changes in ways the new driver would work with the current generation of the HBAs and therefore we do not foresee any impact on the current functionality for these HBAs.
> 
> We would like to solicit community feedback if this approach is acceptable. Alternative would be to leave the current driver untouched and submit a new driver for next generation of HBAs.
> 
> Your inputs would be highly appreciated.

Please just add a new megaraid_<foo> driver, similar to how megaraid_sas
is split from the legacy megaraid driver.  If the shared code is easy
enough to factor it could be moved into a megaraid_common module, but
in doubt I would not even bother with that.

