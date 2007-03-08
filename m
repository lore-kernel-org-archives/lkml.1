Return-Path: <linux-kernel-owner+w=401wt.eu-S1030279AbXCHIc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbXCHIc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030280AbXCHIc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:32:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36115 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279AbXCHIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:32:58 -0500
Date: Thu, 8 Mar 2007 08:32:56 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Brown <dmlb2000@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308083256.GB3532@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Brown <dmlb2000@gmail.com>,
	Roman Zippel <zippel@linux-m68k.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <9c21eeae0703072128i3c63b31em3d132a6691976bf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c21eeae0703072128i3c63b31em3d132a6691976bf4@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:28:15PM -0800, David Brown wrote:
> >While I agree, NBPG is a bit of a problem, although it's only needed for 
> >aout
> >coredumps AFAICT, but still needed to compile e.g. gdb.
> 
> Well then how does gdb deal with ia64? because PAGE_SIZE and friends
> aren't available for that arch same with ppc.

Neither of them support aout core dumps.

