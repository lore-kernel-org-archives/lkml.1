Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbXHKDmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbXHKDmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 23:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXHKDmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 23:42:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53827 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXHKDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 23:42:12 -0400
Date: Sat, 11 Aug 2007 04:42:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-ID: <20070811034207.GA22216@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net
References: <20070723145105.GK26212@stusta.de> <20070809145140.654303a0.kristen.c.accardi@intel.com> <20070809222427.GA32127@suse.de> <20070809154702.caa67a61.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809154702.caa67a61.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 03:47:02PM -0700, Kristen Carlson Accardi wrote:
> fine by me - let's NAK this patch (and all future ones for this driver) until 
> someone with hardware steps up to maintain this driver.  Eventually it
> will just die I guess.

Very bad idea.   For example I sent a patch ages ago to remove kernel_thread
useage from the driver.  We need to get that patch in sooner or later because
the kernel_thread export will have to go away.  We're not going to block that
on this driver.
