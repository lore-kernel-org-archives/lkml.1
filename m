Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZEBO3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZEBO3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbZEBO3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:29:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbZEBO3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:29:40 -0400
Date: Sat, 2 May 2009 10:29:39 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 13/35] parisc: create ptemap.h
Message-ID: <20090502142939.GD28342@bombadil.infradead.org>
References: <20090501144201.D31EF417@kernel> <20090501144221.4C7F3D79@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501144221.4C7F3D79@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:42:21AM -0700, Dave Hansen wrote:
> +#ifndef _PARISC_ASM_PTEMAP_H
> +#define _PARISC_ASM_PTEMAP_H
> +
> +#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
> +#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
> +#define pte_unmap(pte) do { } while (0)
> +#define pte_unmap_nested(pte) do { } while (0)
> +
> +#define pte_unmap(pte)			do { } while (0)
> +#define pte_unmap_nested(pte)		do { } while (0)
> +
> +#endif /* _PARISC_ASM_PTEMAP_H */

You have duplicate definitiosn of pte_unmap{,_nested}?

cheers, Kyle
