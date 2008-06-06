Return-Path: <linux-kernel-owner+w=401wt.eu-S1763020AbYFFWEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763020AbYFFWEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYFFWEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:04:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56463 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYFFWEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:04:31 -0400
Message-ID: <4849B468.8060903@garzik.org>
Date: Fri, 06 Jun 2008 18:04:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI fixes
References: <200806061126.11037.jbarnes@virtuousgeek.org>
In-Reply-To: <200806061126.11037.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Please pull a few more fixes for 2.6.26:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus
> 
> There's nothing big or critical here, just a couple of things that would be
> nice to see in 2.6.26: a fix for OLPC and a new quirk for VIA bridges.
> 
> Thanks,
> Jesse
> 
> Andres Salomon (1):
>       PCI/x86: fix up PCI stuff so that PCI_GOANY supports OLPC
> 
> Bertram Felgenhauer (1):
>       x86/PCI: add workaround for bug in ASUS A7V600 BIOS (rev 1005)
> 
>  arch/x86/Kconfig    |   11 +++++------
>  arch/x86/pci/init.c |    3 ++-
>  arch/x86/pci/irq.c  |    7 +++++++
>  arch/x86/pci/olpc.c |    5 +++--
>  arch/x86/pci/pci.h  |    2 +-
>  5 files changed, 18 insertions(+), 10 deletions(-)

Even though these patches have made a previous appearance on the list, 
any chance you could be talked into including a summary patch, when you 
push upstream?  It's nice to be able to give the push one last look.

	Jeff





