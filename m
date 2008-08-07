Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYHGBJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYHGBJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 21:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYHGBGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 21:06:19 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53880 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYHGBGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 21:06:18 -0400
Date: Thu, 7 Aug 2008 11:06:16 +1000
From: Simon Horman <horms@verge.net.au>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Sven Wegener <sven.wegener@stealer.net>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
Message-ID: <20080807010615.GB24761@verge.net.au>
References: <20080805110006.GA13409@verge.net.au> <20080805111406.GA13899@verge.net.au> <20080805112814.GO26461@parisc-linux.org> <20080805121531.GA29763@verge.net.au> <20080805122639.GP26461@parisc-linux.org> <20080806005718.GE32143@verge.net.au> <20080806131900.GI2055@parisc-linux.org> <20080806232523.GF10636@verge.net.au> <20080806233018.GG10636@verge.net.au> <1218069026.7900.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218069026.7900.0.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 10:30:26AM +1000, Michael Ellerman wrote:
> On Thu, 2008-08-07 at 09:30 +1000, Simon Horman wrote:
> > Check the return value of device_create_bin_file in pci_create_bus and
> > unwind if necessary. Don't propagate error to caller, as failure to create
> > these files shouldn't prevent PCI from being initialised.
> > 
> > Cc: Sven Wegener <sven.wegener@stealer.net>
> > Cc: Michael Ellerman <michael@ellerman.id.au>
> > Cc: Matthew Wilcox <matthew@wil.cx>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> I hate to prolong the pain, but wasn't the plan to print a big fat
> warning so that it's clear the system is not 100% happy.

Sorry, I fogot about that bit.


