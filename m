Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbYKKFsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbYKKFsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYKKFsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:48:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:37146 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYKKFs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:48:29 -0500
Date: Tue, 11 Nov 2008 14:48:11 +0900
To: andi@firstfloor.org
Cc: y-goto@jp.fujitsu.com, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <87d4h3pwhe.fsf@basil.nowhere.org>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com>
	<87d4h3pwhe.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081111144711B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 13:59:57 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Also I believe there are some issues with non continuous memory on
> some IA64 systems -- e.g. Altixes iirc have the requirement
> that you use the IOMMU for higher memory. So it's probably
> not easy to change.

Are you talking about this odd dma requirement?

http://www.gelato.unsw.edu.au/archives/linux-ia64/0305/5604.html
