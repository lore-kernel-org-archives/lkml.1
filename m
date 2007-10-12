Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbXJLCEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbXJLCEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXJLCEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:04:22 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40712 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbXJLCEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:04:22 -0400
Date: Thu, 11 Oct 2007 22:04:19 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Paul Mackerras <paulus@samba.org>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, lethal@linux-sh.org, kyle@parisc-linux.org,
       grundler@parisc-linux.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] powerpc: Switch to generic WARN_ON()/BUG_ON()
Message-ID: <20071012020419.GB19268@fattire.cabal.ca>
References: <20071011171211.GB10877@lixom.net> <20071011171413.GC10877@lixom.net> <18190.52379.97647.468384@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18190.52379.97647.468384@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 11:23:39AM +1000, Paul Mackerras wrote:
> Olof Johansson writes:
> 
> > Not using the ppc-specific WARN_ON/BUG_ON constructs actually saves about
> > 4K text on a ppc64_defconfig. The main reason seems to be that prepping
> > the arguments to the conditional trap instructions is more work than
> > just doing a compare and branch.
> 
> It might be more instructions but it takes fewer cycles, I would
> expect.  Do you have the actual instruction sequences to compare?
> 

I really hope WARN_ON/BUG_ON aren't hotpaths on powerpc. ;-)

Cheers,
	Kyle
