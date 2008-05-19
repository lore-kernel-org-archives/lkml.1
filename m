Return-Path: <linux-kernel-owner+w=401wt.eu-S1763228AbYESSMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763228AbYESSMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYESSMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:12:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38415 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762757AbYESSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:12:43 -0400
Date: Mon, 19 May 2008 12:12:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
Message-ID: <20080519181226.GD2638@parisc-linux.org>
References: <48f7fe350805191047rc5f6f01t2d786380a7dbe199@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350805191047rc5f6f01t2d786380a7dbe199@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 01:47:35PM -0400, Ryan Hope wrote:
> My kernel, and numerous other people have reported to me that their
> kernels hang at boot if CONFIG_HOTPLUG_PCI_PCIE=Y
> 
> If this is set to M or N. The kernel boots fine.
> 
> When I build pciehp as a module, and try to modprobe it after the
> kernel boots, modprobe never returns. I can cancel the operation with
> ctrl+c and then when i run dmesg there are messages that look like the
> module did get inserted.
> Further more, lsmod shows that the module was loaded.
> 
> Seems like there is a small bug in here somehwhere.

You're not giving us much to go on here ...

 - Does your hardware have hotpluggable PCIe slots?
 - What was the last version of the kernel that did work?
 - What messages do you see in dmesg?
 - Can you run 'ps' and get the wchan for the modprobe process to see
   where it's hanging?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
