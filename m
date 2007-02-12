Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXBLIOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXBLIOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933110AbXBLIOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:14:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38580 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106AbXBLIOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:14:32 -0500
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Christoph Hellwig <hch@lst.de>, tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45D025BF.76E4.0078.0@novell.com>
References: <200702070759.l177xIti030295@hera.kernel.org>
	 <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de>
	 <45D025BF.76E4.0078.0@novell.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 12 Feb 2007 09:14:25 +0100
Message-Id: <1171268065.6308.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 07:30 +0000, Jan Beulich wrote:
> On Wed, Feb 07, 2007 at 09:32:54AM +0100, Christoph Hellwig wrote:
> > On Wed, Feb 07, 2007 at 07:59:18AM +0000, Linux Kernel Mailing List wrote:
> > >     [IA64] swiotlb abstraction (e.g. for Xen)
> > >     
> > >     Add abstraction so that the file can be used by environments other than IA64
> > >     and EM64T, namely for Xen.
> > 
> > Tony, this code is more than ugly, and even further not needed for anything
> > we actually need.  Can you please revert it.
> > 
> > Some comments below in case we need justification..
> > 
> > If Jan actually had a goal with that except making the code utterly
> > unreadable he should try again with small patches that are well
> > explained and do one thing at a at time.  (And cane be reviewed an
> > improved on if needed.
> 
> As the topic says - the goal is to support Xen. 

Xen the linux guest
or
Xen the hypervisor?

if it's the later, why on earth would we want to uglyfy linux for it?
(arguably it holds in the former case as well)


