Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbXJ3OOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbXJ3OOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXJ3OOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:14:14 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:48148 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbXJ3OON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:14:13 -0400
Date: Tue, 30 Oct 2007 14:14:01 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kumar Gala <galak@kernel.crashing.org>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071030141401.GB27615@linux-mips.org>
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org> <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org> <20071030083719.GJ32359@parisc-linux.org> <20071030114221.GA24392@linux-mips.org> <20071030121315.GK32359@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030121315.GK32359@parisc-linux.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 06:13:16AM -0600, Matthew Wilcox wrote:

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

Linux has traditionally had a paranoid fear of 64-bit datatypes just
because GCC doesn't generate terribly efficient code for i386.  I think
that may be the primary reason why CONFIG_RESOURCES_64BIT ever became a
build option.  I doubt resource_size_t is being used in any critical
path so the bloat factor will matter much more than the performance
difference it makes.  Unless you're terribly impatient waiting for your
PCI bus to complete scan or so ;-)

  Ralf
