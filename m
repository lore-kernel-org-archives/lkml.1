Return-Path: <linux-kernel-owner+w=401wt.eu-S1751039AbXA0QQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039AbXA0QQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXA0QQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:16:56 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:45950 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXA0QQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:16:56 -0500
Date: Sat, 27 Jan 2007 09:16:54 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Martin Mares <mj@ucw.cz>, Greg KH <greg@kroah.com>, colpatch@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC] pci_bus conversion to struct device
Message-ID: <20070127161654.GA10427@parisc-linux.org>
References: <20070118005344.GA8391@kroah.com> <20070118022352.GA17531@parisc-linux.org> <mj+md-20070118.081204.18154.nikam@ucw.cz> <20070119065805.GA14240@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070119065805.GA14240@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 18, 2007 at 11:58:05PM -0700, Grant Grundler wrote:
> Other per bus attributes might be address routing, VGA routing enabled,
> Fast-back-to-back enabled. PCI-X bridges and PCI-e bridges might also
> advertise data related to MMRBC and similar onboard buffer mgt behaviors.
> 
> ISTR, IBM PCI-X bridge works better with 512 "block" (data xfer size)
> than larger sizes becuase it internally allocates buffer space
> in 512B chunks. It would be useful to know along with downstream
> device MMRBC. Not sure this all has to come from /sys though.

Most of this comes best from lspci / setpci.
