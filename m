Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbYHGXAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbYHGXAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYHGW7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:59:53 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45646 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYHGW7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:59:52 -0400
Date: Fri, 8 Aug 2008 08:59:50 +1000
From: Simon Horman <horms@verge.net.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, Matthew Wilcox <matthew@wil.cx>,
       Sven Wegener <sven.wegener@stealer.net>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
Message-ID: <20080807225950.GA6094@verge.net.au>
References: <20080805111406.GA13899@verge.net.au> <20080807010615.GB24761@verge.net.au> <20080807045632.GA2018@verge.net.au> <200808070950.51400.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808070950.51400.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 09:50:50AM -0700, Jesse Barnes wrote:
> On Wednesday, August 6, 2008 9:56 pm Simon Horman wrote:
> > Check the return value of device_create_bin_file in pci_create_bus and
> > unwind if necessary. Don't propagate error to caller, as failure to create
> > these files shouldn't prevent PCI from being initialised. Instead, just
> > log a warning.
> >
> > Cc: Sven Wegener <sven.wegener@stealer.net>
> > Cc: Michael Ellerman <michael@ellerman.id.au>
> > Cc: Matthew Wilcox <matthew@wil.cx>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Applied, thanks for your persistence, Simon! :)

Thanks, sorry for not getting it right much earlier.
