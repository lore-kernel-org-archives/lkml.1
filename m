Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZH1RpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZH1RpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 13:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZH1RpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 13:45:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:54726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZH1RpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 13:45:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208";a="443605620"
Date: Fri, 28 Aug 2009 19:47:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: TWL4030: Add support for TWL4030/5030 dynamic
 power switching
Message-ID: <20090828174722.GB6162@sortiz.org>
References: <1250517469-15899-1-git-send-email-amit.kucheria@verdurent.com>
 <1250517706-16053-1-git-send-email-amit.kucheria@verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250517706-16053-1-git-send-email-amit.kucheria@verdurent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Mon, Aug 17, 2009 at 05:01:46PM +0300, Amit Kucheria wrote:
> +
> +#include <asm/mach-types.h>
You'll have to make your Kconfig entry depend on ARM if you want to include
this file. Too bad you need it just for the special sdp and ldp cases, but I
guess there's no other solution.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
