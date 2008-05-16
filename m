Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYEPDy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYEPDy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYEPDyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:54:18 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40016 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbYEPDyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:54:18 -0400
Date: Fri, 16 May 2008 12:44:53 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <482C14E4.9050201@firstfloor.org>
References: <482C02A4.80101@firstfloor.org>
	<20080515184126O.tomof@acm.org>
	<482C14E4.9050201@firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080516124446B.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 12:48:04 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > I thought that KVM people want to do it per device (in the first
> > case). So with my patchse, they can replace the dma_ops pointer in
> > dev_archdata with what they want.
> 
> But where would they save the original pointer?

Yeah, we need an extra mechanism for that but it's same for the
system-wide dma_ops pointer (i.e. without my patches), isn't it?

I'm still not sure how this patchset make it impossible to have stack
dma_ops. These people need per-device dma_ops and we can do stack
per-device dma_ops?
