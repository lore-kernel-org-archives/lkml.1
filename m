Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbZCTAPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbZCTAPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZCTAO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:14:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZCTAO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:14:57 -0400
From: Neil Brown <neilb@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Mar 2009 11:14:53 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18882.57341.196519.507194@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH 09/13] iop-adma: P+Q self test
In-Reply-To: message from Dan Williams on Wednesday March 18
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	<20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday March 18, dan.j.williams@intel.com wrote:
> Even though the intent is to extend dmatest with P+Q tests there is
> still value in having an always-on sanity check to prevent an
> unintentionally broken driver from registering.
> 
> This depends on raid6_pq.ko for verification, the side effect being that
> PQ capable channels will fail to register when raid6 is disabled.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dma/iop-adma.c |  182 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 181 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
> index 0cdb333..2b014b6 100644
> --- a/drivers/dma/iop-adma.c
> +++ b/drivers/dma/iop-adma.c
> @@ -31,6 +31,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/memory.h>
>  #include <linux/ioport.h>
> +#include <linux/raid/raid6.h>

???
 <linux/raid/pq.h>  Maybe?

NeilBrown
