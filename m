Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXEFLpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXEFLpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbXEFLpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:45:18 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3666 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXEFLpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:45:16 -0400
Date: Sun, 6 May 2007 12:44:54 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Message-ID: <20070506114453.GB29643@flint.arm.linux.org.uk>
Mail-Followup-To: Robin Getz <rgetz@blackfin.uclinux.org>,
	Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Paul Mundt <lethal@linux-sh.org>
References: <46382055.8030203@snapgear.com> <200705030735.36879.rgetz@blackfin.uclinux.org> <4639E40D.6030809@snapgear.com> <200705041212.03614.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705041212.03614.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 12:12:03PM -0400, Robin Getz wrote:
> > > Depending on how TASK_SIZE is defined - it looks like everyone else
> > > forces it to end of memory, except 68k[nommu].
> > >
> > > asm-arm/memory.h:#define TASK_SIZE              (CONFIG_DRAM_SIZE)
> >
> > That is one way to handle it. Have you followed all the other
> > uses of TASK_SIZE and verified it is not a problem?
> 
> No, I assumed that Russell/David were smarter than we were, and that doing so 
> would not be a problem :)

Don't look at me - the above came from Hyok, and I just assumed that it
was correct without really understanding it.

I've noticed though that Hyok's gone rather quiet, so I'm not sure
whether we'll ever get ARM uclinux integration complete.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
