Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbXJ3UCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbXJ3UCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXJ3UB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:01:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39339 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXJ3UB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:01:58 -0400
Date: Tue, 30 Oct 2007 20:00:40 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ralf Baechle <ralf@linux-mips.org>, Kumar Gala <galak@kernel.crashing.org>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071030200040.GA13999@flint.arm.linux.org.uk>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>,
	Ralf Baechle <ralf@linux-mips.org>,
	Kumar Gala <galak@kernel.crashing.org>,
	Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org> <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org> <20071030083719.GJ32359@parisc-linux.org> <20071030114221.GA24392@linux-mips.org> <20071030121315.GK32359@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030121315.GK32359@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 06:13:16AM -0600, Matthew Wilcox wrote:
> On Tue, Oct 30, 2007 at 11:42:21AM +0000, Ralf Baechle wrote:
> > On Tue, Oct 30, 2007 at 02:37:19AM -0600, Matthew Wilcox wrote:
> > > On Mon, Oct 29, 2007 at 10:03:16PM -0500, Kumar Gala wrote:
> > > > same HW platform that you want to run with just 32-bit phys (for  
> > > > performance).
> > > 
> > > Have you measured what the performance difference is?
> > 
> > So that's 5668, 256 bytes data and 128 bytes of bss for a total of 6052
> > bytes.  Not a whole lot but I still fear some users on the most
> > claustrophobic systems will mind.
> 
> Oh, sure, I'm not saying I thought there would be no size difference; I
> was just bemused at the suggestion there was a performance difference.
> 
> Unless "won't fit in ROM any more" is considered a performance problem ;-)

I think we've gone way past that that issue NetWinders long ago... in the
2.4 days iirc.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
