Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbXCHPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbXCHPyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXCHPyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:54:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50377 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbXCHPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:54:50 -0500
Subject: Re: PAGE_SIZE Availability Inconsistency
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070308090031.GB7373@infradead.org>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
	 <20070306092917.GA5226@infradead.org>
	 <200703080318.04631.zippel@linux-m68k.org>
	 <20070308090031.GB7373@infradead.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 08 Mar 2007 07:53:49 -0800
Message-Id: <1173369229.3550.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 09:00 +0000, Christoph Hellwig wrote:
> On Thu, Mar 08, 2007 at 03:18:04AM +0100, Roman Zippel wrote:
> > Hi,
> > 
> > On Tuesday 06 March 2007 10:29, Christoph Hellwig wrote:
> > 
> > > PAGE_SIZE should not be available at all.  Please use getpagesize()
> > > instead.
> > 
> > While I agree, NBPG is a bit of a problem, although it's only needed for aout 
> > coredumps AFAICT, but still needed to compile e.g. gdb.
> 
> So we should export this one with an arbitrary value (on multiple page
> size architectures) and a warning, maybe even an __deprecated attached to
> it.

if we think the kernel should export this one, we could do

#ifndef __KERNEL__
#define PAGE_SIZE getpagesize()
#endif


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

