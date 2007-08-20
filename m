Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbXHTI0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbXHTI0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbXHTI01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:26:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34910 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbXHTI00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:26:26 -0400
Message-ID: <46C94FD5.6000006@sgi.com>
Date: Mon, 20 Aug 2007 10:24:53 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: akepner@sgi.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
References: <20070818002746.GU1813@sgi.com>
In-Reply-To: <20070818002746.GU1813@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akepner@sgi.com wrote:
> Define ARCH_DOES_POSTED_DMA, and override the dma_flags_set_dmaflush 
> function. Also define dma_flags_get_direction, dma_flags_get_dmaflush 
> to retrieve the direction and "dmaflush attribute" from flags 
> passed to the sn_dma_map_* functions.
> 

Hi Arthur,

I'm a little concerned about changing the API for the dma_ foo
functions, which are defined cross platform. If you want to change
that, I think it will require updating the documentation explaining
it.

Regarding ARCH_DOES_POSTED_DMA, is that sufficient as a #define or
does it have to be run-time tested? (does it do anything at this
stage). I ask since not all ia64 platforms do posted DMA.

Cheers,
Jes
