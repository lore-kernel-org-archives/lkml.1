Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZD0KAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZD0KAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZD0J7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:59:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbZD0J7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:59:47 -0400
Date: Mon, 27 Apr 2009 05:59:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 30/30] microblaze_mmu_v1: fcntl.h MMU update
Message-ID: <20090427095946.GB12323@infradead.org>
References: <1240821139-7247-22-git-send-email-monstr@monstr.eu> <1240821139-7247-23-git-send-email-monstr@monstr.eu> <1240821139-7247-24-git-send-email-monstr@monstr.eu> <1240821139-7247-25-git-send-email-monstr@monstr.eu> <1240821139-7247-26-git-send-email-monstr@monstr.eu> <1240821139-7247-27-git-send-email-monstr@monstr.eu> <1240821139-7247-28-git-send-email-monstr@monstr.eu> <1240821139-7247-29-git-send-email-monstr@monstr.eu> <1240821139-7247-30-git-send-email-monstr@monstr.eu> <1240821139-7247-31-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240821139-7247-31-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:32:19AM +0200, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/include/asm/fcntl.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/fcntl.h b/arch/microblaze/include/asm/fcntl.h
> index 46ab12d..b4d27f6 100644
> --- a/arch/microblaze/include/asm/fcntl.h
> +++ b/arch/microblaze/include/asm/fcntl.h
> @@ -1 +1,15 @@
> +#ifndef _ASM_MICROBLAZE_FCNTL_H
> +#define _ASM_MICROBLAZE_FCNTL_H
> +
> +#ifndef __uClinux__
> +
> +#define O_DIRECTORY	040000 /* must be a directory */
> +#define O_NOFOLLOW	0100000 /* don't follow links */
> +#define O_LARGEFILE	0200000
> +#define O_DIRECT	0400000 /* direct disk access hint */
> +
> +#endif /* __uClinux__ */
> +
>  #include <asm-generic/fcntl.h>

Again, ABIs should always be the same for MMU vs noMMU.

Also no new port shall override the asm-generic/fcntl.h constants.

