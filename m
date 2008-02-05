Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYBESzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYBESzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbYBESzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:55:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49327 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbYBESza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:55:30 -0500
Date: Tue, 5 Feb 2008 10:51:00 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: ???????????? ?????????????????????? <penguinista@mail.net.mk>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
Message-ID: <20080205185100.GA4633@kroah.com>
References: <200802051840.05237.penguinista@mail.net.mk> <20080205104623.33c5f3e0@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205104623.33c5f3e0@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 10:46:23AM -0800, Arjan van de Ven wrote:
> On Tue, 5 Feb 2008 18:40:04 +0100
> ???????????? ??????????????????????  <penguinista@mail.net.mk> wrote:
> 
> > I've patched my kernel with the PCIe ASPM and after setting
> > echo powersave > /sys/module/pcie_aspm/parameters/policy
> > 
> > I started to experience random hangs of my laptop.
> > Hardware info:
> > Thinkpad x60s 1704-5UG
> 
> the x60's chipset doesn't support ASPM properly afaik... bad idea.

Well, the code shouldn't then cause a crash of the machine :)

thanks,

greg k-h
