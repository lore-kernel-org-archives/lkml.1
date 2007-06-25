Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbXFYI1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbXFYI1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXFYI1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:27:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59626 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXFYI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:27:44 -0400
Date: Mon, 25 Jun 2007 00:20:59 -0700
From: Greg KH <greg@kroah.com>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       davem@davemloft.net, davej@redhat.com
Subject: Re: [PATCH 1/2] [RESEND] PCI: read revision ID by default
Message-ID: <20070625072059.GA32272@kroah.com>
References: <20070625031918.4711.2705.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625031918.4711.2705.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 08:19:18PM -0700, Auke Kok wrote:
> Currently there are 97 occurrences where drivers need the pci
> revision ID. We can do this once for all devices. Even the pci
> subsystem needs the revision several times for quirks. The extra
> u8 member pads out nicely in the pci_dev struct.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

Thanks, I've updated both of these in my tree.

greg k-h
