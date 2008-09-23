Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYIWCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYIWCvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbYIWCvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:51:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:55695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYIWCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:51:08 -0400
Date: Mon, 22 Sep 2008 19:50:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Amit Shah <amit.shah@qumranet.com>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
Message-ID: <20080922195059.008de827@infradead.org>
In-Reply-To: <48D85758.7080303@goop.org>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
	<20080922113619.5075e7e4@infradead.org>
	<20080922183944.GJ24392@amd.com>
	<48D85758.7080303@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 19:41:28 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Joerg Roedel wrote:
> > Its implemented using the per-device dma-ops already there. With
> > this patches there is a list of available dma_ops implementations
> > which are asked in a particular order if they can handle the
> > device. The first implementation which returns true is assigned to
> > the device as the per-device dma_ops structure.
> >
> > (Hmm, maybe the name stackable is misleading, is "dma_ops
> > multiplexing" better?)
> 
> Is per-device the right level?  Wouldn't per-bus make more sense? 

not really; all DMA functions get a device as argument already anyway;
just going to bus makes no sense there.

Even if you set it the same for the whole bus almost all of the time...
the APIs just work per device.

(and device assignment clearly is per device as well)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
