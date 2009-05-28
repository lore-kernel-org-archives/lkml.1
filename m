Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZE1W6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZE1W6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZE1W6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:58:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:48100 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZE1W6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:58:11 -0400
Date: Fri, 29 May 2009 07:57:34 +0900
To: tony.luck@intel.com
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, arnd@arndb.de,
       joerg.roedel@amd.com
Subject: RE: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3A8738DE2@orsmsx505.amr.corp.intel.com>
References: <20090528163853Q.fujita.tomonori@lab.ntt.co.jp>
	<20090528085810.GA24335@elte.hu>
	<57C9024A16AD2D4C97DC78E552063EA3A8738DE2@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090529075758Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 29 May 2009 07:57:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 14:37:37 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> > > > Alternatively I can merge the lot, with suitable acking.
> > >
> > > It would be easier, I think.
> >
> > Yeah, that's certainly fine with me. No sense pulling these apart.
> 
> Part 5/5 (cleaning up long long warnings) is about to be made
> irrelevent.  I have Matthew Wilcox's patch to switch ia64 over
> to using <asm-generic/int-ll64.h> queued up (its in linux-next
> already).

Great! I didn't know that the patch is already in -next (I wrote this
patchset against -tip so I got warnings).

Andrew, please drop the 5/5,
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch in -mm tree.


Thanks,
