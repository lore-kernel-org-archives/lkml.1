Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYA2VjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYA2VjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYA2Viw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:38:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:23083 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYA2Viv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:38:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pX28Syn08+xtP35mIr5Fjq4AMvBz0WhL8gLJLFMbPejVnLuqgU1bmsmOOtuGcHTystY5WWO+5GN3tc253wTPVXLlfB69H+CgssfbDGeajUxp7Gk5it35Mx495GwsDMVTgaIGAFEXX9NcebWiuFZy2txDp+aBpj8rrHa1A/gduok=
Date: Tue, 29 Jan 2008 22:38:08 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch errors on current Linus tree
Message-ID: <20080129213802.GA24705@joi>
References: <20080129170325.GA23544@joi> <20080129201641.GB14857@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129201641.GB14857@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 09:16:41PM +0100, Sam Ravnborg wrote:
> On Tue, Jan 29, 2008 at 06:03:30PM +0100, Marcin Slusarz wrote:
> > Hi
> > I'm getting these warnings on current Linus tree (0ba6c33bcddc64a54b5f1c25a696c4767dc76292):
> > 
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> > WARNING: vmlinux.o(.text+0x1a3c75): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()
> > WARNING: vmlinux.o(.text+0x1e333c): Section mismatch in reference from the function acpi_pci_root_add() to the function .devinit.text:pci_acpi_scan_root()
> > WARNING: vmlinux.o(.meminit.text+0xc5e): Section mismatch in reference from the function free_area_init_node() to the function .init.text:__alloc_bootmem_node()
> > WARNING: vmlinux.o(__ksymtab+0x5400): Section mismatch in reference from the variable __ksymtab_pci_do_scan_bus to the function .devinit.text:pci_do_scan_bus()
> ...
> 
> Thanks for the report Marcin.
> 
> We have a lot of section mismatch warnings at present.
> I am personally awaiting merge of x86.git and first
> batch from Andrew Morton before I start to fix them.
> 
> This is for two reasons:
> 1) I know several warnings are fixed in the two trees
> 2) I expect these two merges to touch a lot of the files
>    where I need to fix the warnings.
> 
> Can you please repost no earlier than when you see -rc1. I hope that
> my builds get down below 25 warnings when we get there (> 120 warnings
> when I did a full build last time).
Ok, I'll do it after rc1.

Marcin
