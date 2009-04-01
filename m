Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbZDAIdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbZDAIdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZDAIdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:33:18 -0400
Received: from relay.atmel.no ([80.232.32.139]:51575 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761398AbZDAIdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:33:16 -0400
Date: Wed, 1 Apr 2009 10:33:07 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] dw_dmac: set CAP_PRIVATE capability for DW DMA
 controller
Message-ID: <20090401103307.27c8426d@hcegtvedt>
In-Reply-To: <20090401070440.326f6e7f@hcegtvedt>
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
	<129600E5E5FB004392DDC3FB599660D790F8C3EB@irsmsx504.ger.corp.intel.com>
	<20090401070440.326f6e7f@hcegtvedt>
Organization: Atmel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009 07:04:40 +0200
Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

> On Tue, 31 Mar 2009 15:01:49 +0100
> "Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:

<snipp>

> > Remember however that you can leave the device generally non-private
> > and attempt as needed to allocate a channel for exclusive usage by
> > dma_request_channel()
> >
> 
> The weird part was that when testing this, the dma_request_channel()
> would not return any channel before DMA_PRIVATE flag was set. I think
> I did this some time ago, I can do a retest with the current 2.6.29
> and see how it behaves.
> 

On 2.6.29 I do not have to set the DMA_PRIVATE flag for
dma_request_channel() to work now. So I guess this patch could be
skipped.

I am quite sure I did the previous testing without any of the DMA
clients enabled. My original work was based on 2.6.29-rc3 IIRC. So I do
not really know why this was needed.

<snipp>

-- 
Best regards,
Hans-Christian Egtvedt
