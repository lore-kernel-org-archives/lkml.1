Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZAXCjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZAXCjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 21:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZAXCiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 21:38:55 -0500
Received: from mga12.intel.com ([143.182.124.36]:44228 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753654AbZAXCiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 21:38:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,315,1231142400"; 
   d="scan'208";a="103352905"
Subject: Re: [patch] SLQB slab allocator (try 2)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090123154653.GA14517@wotan.suse.de>
References: <20090123154653.GA14517@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 10:38:46 +0800
Message-Id: <1232764726.11429.185.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 16:46 +0100, Nick Piggin wrote:
> Hi,
> 
> Since last time, fixed bugs pointed out by Hugh and Andi, cleaned up the
> code suggested by Ingo (haven't yet incorporated Ingo's last patch).
> 
> Should have fixed the crash reported by Yanmin (I was able to reproduce it
> on an ia64 system and fix it).
> 
> Significantly reduced static footprint of init arrays, thanks to Andi's
> suggestion.
> 
> Please consider for trial merge for linux-next.
When applying the patch to 2.6.29-rc2, I got:
[ymzhang@lkp-h01 linux-2.6.29-rc2_slqb0123]$ patch -p1<../patch-slqb0123
patching file include/linux/rcupdate.h
patching file include/linux/slqb_def.h
patching file init/Kconfig
patching file lib/Kconfig.debug
patching file mm/slqb.c
patch: **** malformed patch at line 4042: Index: linux-2.6/include/linux/slab.h


