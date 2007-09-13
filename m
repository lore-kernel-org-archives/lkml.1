Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbXIMKp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbXIMKp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 06:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXIMKpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 06:45:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35676 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXIMKpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 06:45:49 -0400
Date: Thu, 13 Sep 2007 03:47:04 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <ak@suse.de>
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case
	MMCONFIG is used
Message-ID: <20070913104704.GA3878@kroah.com>
References: <200709121921.43950.yinghai.lu@sun.com> <200709131147.43446.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709131147.43446.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 11:47:42AM +0200, Andi Kleen wrote:
> On Thursday 13 September 2007 04:21, Yinghai Lu wrote:
> > [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used.
> >
> > reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
> 
> I just rejected a similar patch -- this should be done using MMCONFIG

But what about for broken machines without the proper MMCONFIG entries?
They still need a way to get access to this config space, so why should
we not also work properly for them?

Until we can somehow flog all BIOS developers until they fix all of
their bugs, we have to be able to handle things like this :(

thanks,

greg k-h
