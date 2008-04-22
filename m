Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYDVS15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYDVS15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYDVS1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:27:47 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62341 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753935AbYDVS1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:27:47 -0400
Date: Tue, 22 Apr 2008 19:26:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Daniel Jacobowitz <dan@debian.org>
cc: David Daney <ddaney@avtrex.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch 6/6] Ptrace support for HARDWARE_WATCHPOINTS.
In-Reply-To: <20080422162343.GA14790@caradoc.them.org>
Message-ID: <Pine.LNX.4.55.0804221923010.23679@cliff.in.clinika.pl>
References: <480D2151.2020701@avtrex.com> <480D33EB.30808@avtrex.com>
 <20080422162343.GA14790@caradoc.them.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Daniel Jacobowitz wrote:

> On Mon, Apr 21, 2008 at 05:40:11PM -0700, David Daney wrote:
> > +struct mips32_watch_regs {
> > +	unsigned int num_valid;
> > +	unsigned int reg_mask;
> > +	unsigned int irw_mask;
> > +	unsigned long watchlo[8];
> > +	unsigned int watchhi[8];
> > +};
> 
> Please do not use long in new ptrace interfaces.  Use either
> uint32_t or uint64_t as appropriate so that it doesn't depend
> on how the kernel or debugger was built.

 A minor nit from my side too -- since it is a new API it may be wise to
move wider structure members to the beginning not to waste gaps in memory
due to alignment.

  Maciej
