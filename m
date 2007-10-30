Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbXJ3Lmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbXJ3Lmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXJ3Lmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:42:35 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:46336 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXJ3Lme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:42:34 -0400
Date: Tue, 30 Oct 2007 11:42:21 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kumar Gala <galak@kernel.crashing.org>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071030114221.GA24392@linux-mips.org>
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org> <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org> <20071030083719.GJ32359@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030083719.GJ32359@parisc-linux.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 02:37:19AM -0600, Matthew Wilcox wrote:

> On Mon, Oct 29, 2007 at 10:03:16PM -0500, Kumar Gala wrote:
> > The same is true on PPC32.  Its a per platform thing.   However, I'm  
> > not sure if we could hide it from the user.  There are cases on the  
> > same HW platform that you want to run with just 32-bit phys (for  
> > performance).
> 
> Have you measured what the performance difference is?

Two identical kernel configs, one with one without CONFIG_RESOURCES_64BIT:

   text    data     bss     dec     hex filename
3334684  152208  138624 3625516  37522c vmlinux
3340352  152464  138752 3631568  3769d0 vmlinux

So that's 5668, 256 bytes data and 128 bytes of bss for a total of 6052
bytes.  Not a whole lot but I still fear some users on the most
claustrophobic systems will mind.

  Ralf
