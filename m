Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZFVOpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZFVOpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZFVOpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:45:02 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:9412 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514AbZFVOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:45:01 -0400
Date: Mon, 22 Jun 2009 17:45:01 +0300
From: Dragos Tatulea <dtatulea@ixiacom.com>
To: linux-kernel@vger.kernel.org
Cc: Octavian Purdila <opurdila@ixiacom.com>,
       Dragos Tatulea <dtatulea@ixiacom.com>
Subject: dmaengine: the purpouse of dma_async_tx_callback
Message-ID: <20090622174501.5187e750@dragos-tp.localdomain>
Organization: IXIA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 14:45:01.0442 (UTC) FILETIME=[05A14620:01C9F348]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	What is the purpouse of dma_async_tx_callback from
	dma_async_tx_descriptor in the dma engine api context? It can be called
	only from the engine side and I can't see the point in that.

	At a first glance it looks like a way of notifying the dma clients of
	the descriptor completion, but on closer inspection dma clients don't
	have access to the dma_async_tx_descriptor structure, they only have
	the cookie. It would be really useful to notify clients of operation
	completion via this callback and I'd gladly provide a patch for that.

Thanks,
Dragos
