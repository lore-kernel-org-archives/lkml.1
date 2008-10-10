Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYJJQeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYJJQeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759212AbYJJQeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:34:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53571 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbYJJQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:34:08 -0400
Date: Fri, 10 Oct 2008 10:33:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081010163350.GF25780@parisc-linux.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <20081010114002D.fujita.tomonori@lab.ntt.co.jp> <200810100848.09557.jbarnes@virtuousgeek.org> <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 09:19:08AM -0700, Yinghai Lu wrote:
> anyway looking at dma_mask print out is interesting..., some uses 39,
> and some use 44bits...

Yes, that reflects the limitations of the device.  You can see many of
the common ones in include/linux/dma-mapping.h.

By the way, commit 8f286c33f1e838d631f4a3260b33efce4bc5973c is a really
bad idea.  It is very helpful to see which bitmasks are used by real
devices, and which ones aren't.  It should be reverted, IMO.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
