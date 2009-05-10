Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZEJTIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZEJTIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 15:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZEJTIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 15:08:37 -0400
Received: from verein.lst.de ([213.95.11.210]:47662 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZEJTIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 15:08:37 -0400
Date: Sun, 10 May 2009 21:08:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH 08/15] powerpc/cell: Extract duplicated IOPTE_* to <asm/iommu.h>
Message-ID: <20090510190825.GB23659@lst.de>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 04:01:17PM +0200, Geert Uytterhoeven wrote:
> +/* Cell page table entries */
> +#define IOPTE_PP_W		0x8000000000000000ul /* protection: write */
> +#define IOPTE_PP_R		0x4000000000000000ul /* protection: read */
> +#define IOPTE_M			0x2000000000000000ul /* coherency required */
> +#define IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
> +#define IOPTE_SO_RW             0x1800000000000000ul /* ordering: r & w */
> +#define IOPTE_RPN_Mask		0x07fffffffffff000ul /* RPN */
> +#define IOPTE_H			0x0000000000000800ul /* cache hint */
> +#define IOPTE_IOID_Mask		0x00000000000007fful /* ioid */

If this is in a global header it should probably have a CELL_ prefix.
