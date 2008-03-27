Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYC0Hyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYC0Hyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYC0Hya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:54:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519AbYC0Hy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:54:29 -0400
Date: Thu, 27 Mar 2008 00:54:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: York Sun <yorksun@freescale.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       a.p.zijlstra@chello.nl, Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/2 v3] Driver for Freescale 8610 and 5121 DIU
Message-Id: <20080327005403.18d6ab07.akpm@linux-foundation.org>
In-Reply-To: <12064804383051-git-send-email-yorksun@freescale.com>
References: <120648043867-git-send-email-yorksun@freescale.com>
	<12064804383051-git-send-email-yorksun@freescale.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 16:27:17 -0500 York Sun <yorksun@freescale.com> wrote:

> +#if defined(CONFIG_NOT_COHERENT_CACHE)
> +unsigned int *coherence_data;
> +phys_addr_t *coherence_data_phy;
> +#endif

These identifiers are too general for use as global symbols.  I'd suggest
renaming them to diu_coherence_data and diu_coherence_data_phy.  Or make
them static - I didn't check.

I'll duck this version of the patches, as Scott's comments looked rather
substantial.

