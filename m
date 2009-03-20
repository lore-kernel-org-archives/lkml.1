Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbZCTAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbZCTAaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZCTAaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:30:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZCTAaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:30:15 -0400
From: Neil Brown <neilb@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Mar 2009 11:30:11 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18882.58259.565999.429909@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
In-Reply-To: message from Dan Williams on Wednesday March 18
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday March 18, dan.j.williams@intel.com wrote:
> This series constitutes the pieces of the raid6 acceleration work that are
> aimed at the next merge window.  It implements:
> 1/ An api for asynchronous raid6 parity generation and recovery routines
> 2/ Extensions to the dmaengine framework and dmatest
> 3/ RAID6 support for iop13xx
> 4/ Removal of the BUILD_BUG_ON in async_xor to support platforms with
>    sizeof(dma_addr_t) > sizeof(void *).  This increases the stack
>    utilization in the asynchronous path.
> 
> This series is available via git at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6
> 
> ...it is based on git://neil.brown.name/md md-scratch

Thanks.

I'll take the first patch (which is the only one that affects md
directly) and feed it to -next and eventually -linus.  I'll leave the
rest for you.

> 
> Part 2, which needs more testing, is the conversion of md/raid6.  It is
> available at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git raid6-for-neil

Thanks.  I might have a look if I get a moment.

NeilBrown
