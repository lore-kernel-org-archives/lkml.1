Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZBWPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZBWPWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZBWPWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:22:36 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:48332 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZBWPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:22:36 -0500
Date: Mon, 23 Feb 2009 15:22:25 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, rui.zhang@intel.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not ioremap virtual address for G33 hw status page
Message-ID: <20090223152225.GA12909@silver.sucs.org>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 03:46:41PM +0100, Maciej Rutecki wrote:
> 2.6.29-rc5 and 2.6.29-rc5-git6 work OK. In 2.6.29-rc6 XWindow (KDM)
> doesn't start, from dmesg:
> 
> [   18.170614] [drm] Initialized drm 1.1.0 20060810
> [   18.247445] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   18.247455] pci 0000:00:02.0: setting latency timer to 64
> [   18.249610] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   18.249621] [drm] MTRR allocation failed
> [   18.249622] .  Graphics performance may suffer.

Does enabling mtrr cleanup as described on
http://marc.info/?l=linux-kernel&m=123501581629566&w=2 help?

-- 
Sitsofe | http://sucs.org/~sits/
