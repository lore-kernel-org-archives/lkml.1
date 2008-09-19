Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYISSlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYISSlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYISSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:41:00 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:38996 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYISSk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:40:59 -0400
Date: Sat, 20 Sep 2008 03:40:32 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919174605.GU24392@amd.com>
References: <20080919172036.GT24392@amd.com>
	<20080920023424H.fujita.tomonori@lab.ntt.co.jp>
	<20080919174605.GU24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920033021K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 19:46:05 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 02:34:15AM +0900, FUJITA Tomonori wrote:
> > > You keep this option for AMD IOMMU too. If you move it to AMD IOMMU code
> > > then you can remove nofullflush there.
> > 
> > I'm not sure what you mean. You think that we can't change the
> > exported option, how can we remove nofullflush option?
> 
> You can keep it for GART. But as I already wrote its ok to remove it for
> AMD IOMMU.

My patch doesn't add nofullflush option to AMD IOMMU. So we don't
remove to it.

If my patch adds it to AMD IOMMU, it's a bug.
