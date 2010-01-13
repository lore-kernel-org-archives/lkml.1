Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110Ab0AMIYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0AMIYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221Ab0AMIYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:24:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:65301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab0AMIYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:24:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232172156"
Subject: Re:
From: David Woodhouse <david.woodhouse@intel.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Song, Youquan" <youquan.song@intel.com>
In-Reply-To: <20100113004938.881146778@suse.com>
References: <20100113004938.881146778@suse.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Wed, 13 Jan 2010 08:24:09 +0000
Message-ID: <1263371049.16257.6172.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 00:48 +0000, Jeff Mahoney wrote:
> Subject: [patch 3/6] dmar: Fix section mismatch
> References: <20100113004855.550486769@suse.com>
> Content-Disposition: inline;
> filename=patches.rpmify/dmar-fix-section-mismatch
> 
>  dmar_ir_support uses dmar_tbl, which is __initdata. dmar_ir_support
> is
>  only called by intr_remapping_supported, which is __init. So, we mark
>  dmar_ir_support as __init as well.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com> 

This patch doesn't apply to linux-next, and hasn't applied there for
about two weeks. Why are people still sending it to me?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

