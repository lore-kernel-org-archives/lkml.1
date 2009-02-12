Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbZBLOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbZBLOs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZBLOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:48:16 -0500
Received: from 8bytes.org ([88.198.83.132]:37018 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBLOsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:48:15 -0500
Date: Thu, 12 Feb 2009 15:48:13 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/16] DMA-API debugging facility v2
Message-ID: <20090212144813.GA2125@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1233874352.8135.12.camel@macbook.infradead.org> <20090206020535.GE27684@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206020535.GE27684@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:05:35PM -0800, Chris Wright wrote:

> (interesting hash_fn spread ;-)

Hmm, thats because all device addresses are 16kb aligned. The hashfn
uses bits 13 to 21 as the index for the hash. I can move this window up
to bits 18-26 if it improves the hash spread.

Joerg
