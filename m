Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZDXEXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZDXEXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZDXEXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:23:33 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:36509 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZDXEXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:23:32 -0400
Date: Fri, 24 Apr 2009 06:23:10 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] MIPS: Extend plat_* abstractions, cache support
Message-ID: <20090424042310.GA19096@linux-mips.org>
References: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0483452db22e72f57289e63fcf097120d94c2a37.1240533480.git@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 05:03:43PM -0700, Kevin Cernekee wrote:

> I am upgrading an SoC to the 2.6.29.1 kernel from an earlier version,
> and in the process I am switching over the old board support
> customizations to use the newer, cleaner plat_* functions.  I found two
> cases where the plat_* functions did not provide enough information,
> so I had to modify the API:
> 
> plat_unmap_dma_mem() - Our handler needs to know the size and direction
> of the DMA mapping.  This information is not encoded in the DMA address,
> so it needed to be passed in explicitly.
> 
> plat_dma_addr_to_phys() - The bus<->physical address mappings differ
> based on which bus is being used.  It is not always possible to infer
> which bus is being used from the bus address alone, so I added a
> "struct device" to the function definition.
> 
> Also, our MIPS core uses 64-byte D$ lines, so I needed to generate the
> corresponding blast* functions.
> 
> These patches apply against the linux-mips.org GIT tree.

Queued for 2.6.31.  Thanks Kevin!

Which SoC port are you working on btw?

  Ralf
