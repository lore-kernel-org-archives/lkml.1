Return-Path: <linux-kernel-owner+w=401wt.eu-S934040AbYA2UQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbYA2UQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYA2UQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:16:41 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52121 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYA2UQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:16:40 -0500
Date: Tue, 29 Jan 2008 21:16:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch errors on current Linus tree
Message-ID: <20080129201641.GB14857@uranus.ravnborg.org>
References: <20080129170325.GA23544@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129170325.GA23544@joi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 06:03:30PM +0100, Marcin Slusarz wrote:
> Hi
> I'm getting these warnings on current Linus tree (0ba6c33bcddc64a54b5f1c25a696c4767dc76292):
> 
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x1a3c75): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()
> WARNING: vmlinux.o(.text+0x1e333c): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()
> WARNING: vmlinux.o(.meminit.text+0xc5e): Section mismatch in reference from the function free_area_init_node() to the function .init.text:__alloc_bootmem_node()
> WARNING: vmlinux.o(__ksymtab+0x5400): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()
...

Thanks for the report Marcin.

We have a lot of section mismatch warnings at present.
I am personally awaiting merge of x86.git and first
batch from Andrew Morton before I start to fix them.

This is for two reasons:
1) I know several warnings are fixed in the two trees
2) I expect these two merges to touch a lot of the files
   where I need to fix the warnings.

Can you please repost no earlier than when you see -rc1. I hope that
my builds get down below 25 warnings when we get there (> 120 warnings
when I did a full build last time).

	Sam
