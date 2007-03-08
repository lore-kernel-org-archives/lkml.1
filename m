Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXCHJAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXCHJAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030347AbXCHJAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:00:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49650 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346AbXCHJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:00:33 -0500
Date: Thu, 8 Mar 2007 09:00:31 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308090031.GB7373@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	David Brown <dmlb2000@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703080318.04631.zippel@linux-m68k.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 03:18:04AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Tuesday 06 March 2007 10:29, Christoph Hellwig wrote:
> 
> > PAGE_SIZE should not be available at all.  Please use getpagesize()
> > instead.
> 
> While I agree, NBPG is a bit of a problem, although it's only needed for aout 
> coredumps AFAICT, but still needed to compile e.g. gdb.

So we should export this one with an arbitrary value (on multiple page
size architectures) and a warning, maybe even an __deprecated attached to
it.

