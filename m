Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXHTQIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXHTQIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760899AbXHTQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:08:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34886 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760869AbXHTQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:08:09 -0400
From: akepner@sgi.com
Date: Mon, 20 Aug 2007 09:07:09 -0700
To: Jes Sorensen <jes@sgi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070820160709.GA28963@sgi.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C94FD5.6000006@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 10:24:53AM +0200, Jes Sorensen wrote:

> I'm a little concerned about changing the API for the dma_ foo
> functions, which are defined cross platform. If you want to change
> that, I think it will require updating the documentation explaining
> it.

Good idea. I'll post a documentation patchette.

> 
> Regarding ARCH_DOES_POSTED_DMA, is that sufficient as a #define or
> does it have to be run-time tested? (does it do anything at this
> stage). I ask since not all ia64 platforms do posted DMA.
> 

I think a #define is exactly what we want here. 

The newly #define-ed function (for now, and maybe forever) does 
nothing except on IA64_SGI_SN2, which does posted DMA. 

-- 
Arthur

