Return-Path: <linux-kernel-owner+w=401wt.eu-S935355AbZJOVsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355AbZJOVsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934871AbZJOVsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:48:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560AbZJOVsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:48:52 -0400
Date: Thu, 15 Oct 2009 17:48:05 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, Nitin Gupta <ngupta@vflare.org>,
       Nick Piggin <npiggin@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Paul Mundt <lethal@lethal-sh.org>,
       Chen Liqin <liqin.chen@sunplusct.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
Message-ID: <20091015214805.GP11702@bombadil.infradead.org>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org> <20091012090710.GA29310@n2100.arm.linux.org.uk> <20091012.023744.157085851.davem@davemloft.net> <20091012100023.GC29310@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0910121634170.7327@sister.anvils> <20091012170312.GB9453@flint.arm.linux.org.uk> <Pine.LNX.4.64.0910121855070.21347@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910121855070.21347@sister.anvils>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 07:06:04PM +0100, Hugh Dickins wrote:
> The architectures which appear to need fixing in the same way are
> arm, mips, parisc, sh and sparc64 (xtensa looks right already, and
> score just looks confused - a whole function __update_cache() which
> checks for PG_arch_1, yet nothing sets it?).
> 

parisc looks affected as well, though I don't recall the semantics of
dcache flushing without a mapping. James, can you send a patch?

WRT score, which seems to have been mostly cobbled together as a modern
copy of mips, it can likely be eliminated entirely, as it looks to have
been cargoculted from mips without thought.

regards, Kyle
