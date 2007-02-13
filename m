Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbXBMHxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbXBMHxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXBMHxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:53:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35544 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXBMHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:53:53 -0500
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Christoph Hellwig <hch@lst.de>, tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45D17660.76E4.0078.0@novell.com>
References: <200702070759.l177xIti030295@hera.kernel.org>
	 <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de>
	 <45D025BF.76E4.0078.0@novell.com> <20070212171224.GA18430@lst.de>
	 <45D17660.76E4.0078.0@novell.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 08:53:41 +0100
Message-Id: <1171353226.12771.39.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 07:27 +0000, Jan Beulich wrote:
> >>> Christoph Hellwig <hch@lst.de> 12.02.07 18:12 >>>
> >On Mon, Feb 12, 2007 at 07:30:55AM +0000, Jan Beulich wrote:
> >> 
> >> As the topic says - the goal is to support Xen. But yes, I was afraid someone would
> >> claim this make the code look ugly. And no, I currently don't have ideas to address
> >> any of your comments without breaking functionality on Xen...
> >
> >We don't have Xen merged, and it doesn't look like we're going to get it
> >soon.  Also the code is only for dom0 which will take even longer.
> >At this point I'm pretty sure the code is cleaner, simpler and easier to
> >maintain if you just split out a xendom0swiotlb instead of messing up
> >the existing code.
> 
> We have such a file, and the purpose of the patch was to get rid of it.


but the result is butt-ugly... please don't do that... that code is..
interesting enough already without all the junk added to it

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

