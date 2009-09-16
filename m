Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZIPO4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZIPO4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:56:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZIPO4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:56:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbZIPO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:56:00 -0400
Date: Wed, 16 Sep 2009 07:55:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
In-Reply-To: <20090915132105.2fdd1d45@jbarnes-g45>
Message-ID: <alpine.LFD.2.01.0909160753000.4950@localhost.localdomain>
References: <20090915132105.2fdd1d45@jbarnes-g45>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Sep 2009, Jesse Barnes wrote:
>
> The following changes since commit 332a3392188e0ad966543c87b8da2b9d246f301d:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../herbert/crypto-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 linux-next
> 
> There are a few important changes in here:
>   - support for PCIe fundamental reset from Mike (needed for error recovery on
>     some devices)

This one clashed trivially with the powerpc merge ("move pci_64.c device 
tree scanning code into pci-common.c" clashes with "PCI/powerpc: support
PCIe fundamental reset.")

I fixed it up, and I'm pretty sure it's all ok (it really was just a 
function movement and a single new added line), but ppc PCI people should 
double-check the result.

		Linus
