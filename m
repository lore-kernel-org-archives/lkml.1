Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYI3HLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYI3HLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYI3HL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:11:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:48674 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752339AbYI3HL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:11:28 -0400
Date: Tue, 30 Sep 2008 09:11:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0809300906550.4022@jikos.suse.cz>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>  <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>  <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
 <alpine.LFD.2.00.0809291909360.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Linus Torvalds wrote:

> > If it is X related then its both a kernel + X server issue, the e1000e 
> > driver opens the barn door, the X server drives the horses through it.
> Are you sure? There was a mandriva report abou NVM corruption on an e100 
> too (that one apparently just caused PXE failure, the networking worked 
> fine).

That is very probably completely separate issue, and shoudl have been 
fixed already by 78566fecb.

> The Ubuntu people are some of the crazier ones (should I be surprised?), 
> but that one also has Ben Collins claiming they use the same e1000e 
> driver for the 2.6.26/27 kernels (from intels sf.net project). That may 
> be bogus, but if true it would indicate that it's possibly not so 
> kernel-related, or at least not so e1000e-driver-related.

I think that not many peeople are suspecting bug in e1000e directly. 
Rather a combination of X bug, kernel allowing X to do bad things (for 
example the missing check in drivers/pci/pci-sysfs.c:pci_mmap_resource() 
looks particularly suspicious) and a "bug-friendly" hardware behavior.

-- 
Jiri Kosina
SUSE Labs
