Return-Path: <linux-kernel-owner+w=401wt.eu-S936961AbZLHXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936961AbZLHXKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936463AbZLHXKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:10:20 -0500
Received: from waste.org ([173.11.57.241]:55739 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935891AbZLHXKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:10:20 -0500
Subject: Re: [PATCH] [19/31] mm: export stable page flags
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: fengguang.wu@intel.com, npiggin@suse.de, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20091208211635.7965AB151F@basil.firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
	 <20091208211635.7965AB151F@basil.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 16:27:31 -0600
Message-ID: <1260311251.31323.129.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 22:16 +0100, Andi Kleen wrote:
> From: Wu Fengguang <fengguang.wu@intel.com>
> 
> Rename get_uflags() to stable_page_flags() and make it a global function
> for use in the hwpoison page flags filter, which need to compare user
> page flags with the value provided by user space.
> 
> Also move KPF_* to kernel-page-flags.h for use by user space tools.
> 
> CC: Matt Mackall <mpm@selenic.com>
> CC: Nick Piggin <npiggin@suse.de>
> CC: Christoph Lameter <cl@linux-foundation.org>
> CC: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Matt Mackall <mpm@selenic.com>
-- 
http://selenic.com : development and support for Mercurial and Linux


