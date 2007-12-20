Return-Path: <linux-kernel-owner+w=401wt.eu-S1765978AbXLTRfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765978AbXLTRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757839AbXLTRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:35:30 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34205 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXLTRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:35:29 -0500
Date: Thu, 20 Dec 2007 10:35:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <gregkh@suse.de>
Cc: Tony Camuso <tcamuso@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071220173528.GE29690@parisc-linux.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220172205.GB5636@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 09:22:05AM -0800, Greg KH wrote:
> > The one device we know about that throws exceptions is the 830M/MG
> > graphics chip. This chip passes the read-compare test, so the code
> > merrily advances to bus sizing. When the bus sizing code writes the
> > BAR at offset 0x18 in this device, the system hangs.
> 
> So it doesn't work at all, with or without this patch?  Does the vendor
> know about this?

I can't imagine there are too many machines with MMCONFIG and an
i830 chipset.  The laptop I'm currently typing on is an i830 ... and
its BIOS is from 2002, well predating the specification of MMCONFIG.
If I didn't know better, I'd accuse Tony of lying about the existance
of such a machine ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
