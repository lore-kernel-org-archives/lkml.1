Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbXEFJvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbXEFJvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXEFJvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:51:53 -0400
Received: from outmx025.isp.belgacom.be ([195.238.4.49]:37388 "EHLO
	outmx025.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbXEFJvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:51:53 -0400
Date: Sun, 6 May 2007 11:52:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Curt E. Bruns" <curt.e.bruns@intel.com>,
       Peter Milne <peter.milne@d-tacq.com>,
       Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 patch] iop: combined watchdog timer driver for iop3xx and iop13xx
Message-ID: <20070506095256.GA2521@infomag.infomag.iguana.be>
References: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177952240.12134.10.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

> Here is a new watchdog driver for your review.  It supports two flavors
> of the iop watchdog timer.  The iop13xx watchdog can be stopped while
> the iop3xx version cannot.

I started reviewing this patch yesterday. First thing I noticed was that
you seem to be moving some code from include/asm-arm/arch-iop13xx/system.h
to include/asm-arm/arch-iop13xx/iop13xx.h .
This should not be part of this patch since it is touching architecture
dependant code for which I do not have enough knowledge about this specific
architecture to tell if this is indeed the correct way to do this.
The maintainers of this architecture should imho comment on this.
Could you split this patch into 2 patches: one that deals with the moving of
the architecture dependant code (and explaining why) and one with the new
watchdog drivers? I will continue my review today.

Thanks,
Wim.

