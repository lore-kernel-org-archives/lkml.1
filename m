Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXHFWaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXHFWaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXHFWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:30:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:42914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbXHFWaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:30:21 -0400
Date: Tue, 7 Aug 2007 00:30:19 +0200
From: Olaf Hering <olh@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Robert Hancock <hancockr@shaw.ca>, linuxppc-dev@ozlabs.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc: Fix initialization and usage of dma_mask
Message-ID: <20070806223019.GA19389@suse.de>
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no> <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de> <1186272926.938.8.camel@localhost.localdomain> <46B5824B.1000103@s5r6.in-berlin.de> <20070806115804.GA1734@suse.de> <1186436597.938.71.camel@localhost.localdomain> <1186437910.938.79.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1186437910.938.79.camel@localhost.localdomain>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, Benjamin Herrenschmidt wrote:

> powerpc has a couple of bugs in the usage of dma_masks that tend to
> break when drivers explicitely try to set a 32 bits mask for example.
> 
> First the code that generates the pci devices from the OF device-tree
> doesn't initialize the mask properly, then our implementation of
> set_dma_mask() was trying to validate the -previous- mask value, not the
> one passed in as an argument.
> 
> This patch should fix these.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Does this fix the problem you've noticed ?

This patch fixes it. Thanks.
