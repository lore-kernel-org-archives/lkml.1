Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbZCHO6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbZCHO6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZCHO6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:58:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50472 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZCHO6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:58:22 -0400
Date: Sun, 8 Mar 2009 08:58:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: try to detect host_bridge pci_cfg_space
Message-ID: <20090308145803.GL25995@parisc-linux.org>
References: <49B1C50E.5010209@kernel.org> <49B1C69F.70904@zytor.com> <49B1C81B.5010904@zytor.com> <49B1C8C1.4090304@kernel.org> <20090308110437.GA27811@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308110437.GA27811@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 12:04:37PM +0100, Ingo Molnar wrote:
> I'd also suggest to flip around the subject line from x86/pci to 
> pci/x86 - it's more of a PCI patch than a pure x86 patch. The 
> same problem could affect other platforms too i suspect.

Not all platforms expose the root bridge in PCI configuration space.
Intel ia64 platforms do have a materialised root bridge; HP's don't.
(I don't know whether Intel ship any PCIe ia64 machines or not).  I
don't remember details for other platforms, but I think Intel is the odd
one out in this regard.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
