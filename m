Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYIWClh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYIWClh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYIWCl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:41:28 -0400
Received: from gw.goop.org ([64.81.55.164]:39553 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYIWCl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:41:27 -0400
Message-ID: <48D85758.7080303@goop.org>
Date: Mon, 22 Sep 2008 19:41:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Amit Shah <amit.shah@qumranet.com>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <20080922113619.5075e7e4@infradead.org> <20080922183944.GJ24392@amd.com>
In-Reply-To: <20080922183944.GJ24392@amd.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Its implemented using the per-device dma-ops already there. With this
> patches there is a list of available dma_ops implementations which are
> asked in a particular order if they can handle the device. The first
> implementation which returns true is assigned to the device as the
> per-device dma_ops structure.
>
> (Hmm, maybe the name stackable is misleading, is "dma_ops multiplexing"
>  better?)

Is per-device the right level?  Wouldn't per-bus make more sense?  How
does a dma_ops implementation "know" whether it can handle a particular
device?

(I haven't had a chance to read the patches yet.)

    J
