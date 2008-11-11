Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYKKUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYKKUdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKKUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:33:04 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:48532 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYKKUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:33:04 -0500
Date: Tue, 11 Nov 2008 14:32:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: y-goto@jp.fujitsu.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
In-Reply-To: <20081111145418P.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.64.0811111431440.26610@quilx.com>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
 <Pine.LNX.4.64.0811101600490.32282@quilx.com> <20081111145418P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, FUJITA Tomonori wrote:

> Is it because it does some kinda address translation
> (provider->dma_map_consistent) later? The zone flag is meaningless if
> you do sorta address translation (e.g. hardware IOMMU like VT-d).

Yes it can do address translation. Therefore a < 4G address can show up at
any 64 bit address. So no need for a special DMA zone. The same is true
for more x86_64 platforms that have an IOMMU.


