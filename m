Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYLAOdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYLAOdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYLAOdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:33:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYLAOdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:33:22 -0500
Message-ID: <4933F5A7.8020408@redhat.com>
Date: Mon, 01 Dec 2008 16:33:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, muli@il.ibm.com,
       kvm@vger.kernel.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
References: <20081201173830B.fujita.tomonori@lab.ntt.co.jp> <20081201120026.GF17719@amd.com> <20081201130209.GA21615@il.ibm.com> <20081201231852P.fujita.tomonori@lab.ntt.co.jp> <20081201142727.GL29705@8bytes.org>
In-Reply-To: <20081201142727.GL29705@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hmm, is there any hardware IOMMU with which we can't emulate domains by
> partitioning the IO address space? This concept works for GART and
> Calgary.
>
>   

Is partitioning secure?  Domain X's user could program its hardware to 
dma to domain Y's addresses, zapping away Domain Y's user's memory.

-- 
error compiling committee.c: too many arguments to function

