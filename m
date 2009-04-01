Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbZDARD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbZDARD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbZDARCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:02:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758770AbZDARCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:02:50 -0400
Date: Wed, 1 Apr 2009 10:01:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
In-Reply-To: <20090331121331.3673cf59@hobbes>
Message-ID: <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain>
References: <20090331121331.3673cf59@hobbes>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Jesse Barnes wrote:
>
> Please consider pulling my PCI tree from
>   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next

This produces

  WARNING: drivers/built-in.o(.text+0x69a1): Section mismatch in reference from the function dev_rescan_store() to the function .devinit.text:pci_rescan_bus()
  The function dev_rescan_store() references
  the function __devinit pci_rescan_bus().
  This is often because dev_rescan_store lacks a __devinit 
  annotation or the annotation of pci_rescan_bus is wrong.

Hmm?

> Anyway hope this pull is ok.  I went through every warning by hand to make
> sure none were caused by PCI commits, but that was with the bits in this
> tree, which are -rc8 vintage.

You can tell it's rebased, but at least it's not rebased five minutes ago, 
so I assume it has some testing. It's the "I just rebased a couple of 
minutes before posting this 'please pull' message" that I find really 
annoying, since it's so clear that the end result has no real testing at 
all.

		Linus
