Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXGaRtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXGaRtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbXGaRsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:48:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:57983 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbXGaRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:48:46 -0400
Date: Tue, 31 Jul 2007 10:47:55 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Schwab <schwab@suse.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Satyam Sharma <satyam@infradead.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
	subsystem.
Message-ID: <20070731174755.GA8592@suse.de>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125443.880871000@hawkeye.stone.uk.eu.org> <200707311553.29090.borntraeger@de.ibm.com> <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in> <20070731144619.GA8183@localhost.localdomain> <20070731161051.GA7490@suse.de> <jeir80y27m.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeir80y27m.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 06:20:29PM +0200, Andreas Schwab wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Tue, Jul 31, 2007 at 10:46:19PM +0800, WANG Cong wrote:
> >> However, I think using resource_size_t is a bit better than unsigned long,
> >> so that we don't need to check the defination of it.
> >> 
> >> - res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> >> + res->start = (resource_size_t)kmalloc(*size, GFP_KERNEL);
> >> 
> >> Is this change OK?
> >
> > Yes, that is the proper cast to have here.
> 
> It will generate a warning when resoure_size_t is 64bit on a 32bit arch.

How?  And if so, what should the proper cast be?

thanks,

greg k-h
