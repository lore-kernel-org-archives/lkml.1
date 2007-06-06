Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbXFFFnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbXFFFnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXFFFnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:43:14 -0400
Received: from 1wt.eu ([62.212.114.60]:2877 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbXFFFnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:43:13 -0400
Date: Wed, 6 Jun 2007 07:43:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jeff Garzik <jeff@garzik.org>, Filippo Carletti <carletti@mobilia.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4.34 - Add some ahci pci ids
Message-ID: <20070606054304.GA4241@1wt.eu>
References: <465FE51E.2060705@mobilia.it> <466005C6.4050303@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466005C6.4050303@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 07:40:54AM -0400, Jeff Garzik wrote:
> Filippo Carletti wrote:
> >This patch adds support for some chipsets in ahci driver.
> >The list comes from a patch for redhat kernel 2.6.9-34.
> >I only tested ICH8.
> >
> >The original patch contained also this lines (that I omitted):
> >+       /* JMicron-specific fixup: make sure we're in AHCI mode */
> >+       if (pdev->vendor == 0x197b)
> >+               pci_write_config_byte(pdev, 0x41, 0xa1);
> 
> NAK.  Don't omit obviously needed lines, if you are going to add JMicron 
> PCI IDs.

Filippo,

would you please resend your patch including the lines you have omitted ?
Jeff is right, those lines are explicitly labelled as a fixup, so either
we merge the complete patch, or nothing at all.

I expect to release 2.4.35 around the end of this month, so if you can
provide me with an acceptable patch in time so that I can run at least
one -rc with it, I'm OK to merge it (provided that Jeff has no objection
of course). I will merge your other patch (VIA) at the same time.

Thanks in advance,
Willy

