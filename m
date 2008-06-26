Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYFZXhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYFZXhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 19:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbYFZXhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 19:37:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbYFZXhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 19:37:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for June 26
Date: Fri, 27 Jun 2008 01:38:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh <jaswinder@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
In-Reply-To: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806270138.53895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 of June 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080625:
> 
> The tip-core tree lost its three conflicts against Linus' tree.
> 
> The pci tree gained two conflicts against the x86 tree.
> 
> The v4l-dvb tree had the second revert undone.  We will see if this is
> right.
> 
> The net tree gained a conflict against the wireless-current tree.
> 
> The vfs tree lost its conflict against the sched tree.
> 
> The arm tree lost its conflict against Linus' tree.
> 
> The rr tree gained a patch for a build problem instead the revert.
> 
> The firmware tree lost a conflict against the usb tree.

commit 423c982fffb1cd95c8cdd654ce5ab59351ba41f5
Author: Jaswinder Singh <jaswinder@infradead.org>
Date:   Wed Jun 18 19:58:33 2008 +0530

    firmware: convert tg3 driver to request_firmware()

breaks my nx6325.

Apparently, with this patch applied the tg3 has a NULL pointer dereference
somewhere, but I can only see the first line of the oops, afterwards the box
hangs solid.

Please drop it if possible.

Also, arch/x86/kernel/io_apic_64.c seems wrong at the moment, as it checks
for conditions that are never satisfied etc.

Thanks,
Rafael
