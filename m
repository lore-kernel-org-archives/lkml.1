Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbZDANxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbZDANxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbZDANwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:52:14 -0400
Received: from relay.atmel.no ([80.232.32.139]:52953 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307AbZDANwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:52:12 -0400
Date: Wed, 1 Apr 2009 15:52:05 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH v3 1/1] dw_dmac: add cyclic API to DW DMA driver
Message-ID: <20090401155205.1f47ccc4@hskinnemoen-d830>
In-Reply-To: <1238593622-17809-1-git-send-email-hans-christian.egtvedt@atmel.com>
References: <20090401153957.6982f050@hskinnemoen-d830>
	<1238593622-17809-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Christian Egtvedt wrote:
> This patch adds a cyclic DMA interface to the DW DMA driver. This is
> very useful if you want to use the DMA controller in combination with a
> sound device which uses cyclic buffers.
> 
> Using a DMA channel for cyclic DMA will disable the possibility to use
> it as a normal DMA engine until the user calls the cyclic free function
> on the DMA channel. Also a cyclic DMA list can not be prepared if the
> channel is already active.
> 
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
