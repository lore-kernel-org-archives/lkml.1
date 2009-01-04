Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZADMKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZADMKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZADMKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:10:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:46881 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZADMKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:10:12 -0500
Date: Sun, 4 Jan 2009 21:04:25 +0900
To: mingo@elte.hu
Cc: jj@chaosbits.net, weiyi.huang@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove duplicated #include
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090104112541.GA25434@elte.hu>
References: <20090104110951.C9AB.WEIYI.HUANG@gmail.com>
	<alpine.LNX.2.00.0901041057400.26359@swampdragon.chaosbits.net>
	<20090104112541.GA25434@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090104210420X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 12:25:43 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesper Juhl <jj@chaosbits.net> wrote:
> 
> > On Sun, 4 Jan 2009, Huang Weiyi wrote:
> > 
> > > Removed duplicated #include in lib/swiotlb.c.
> > > 
> > 
> > This is identical to a patch I already submitted - 
> > http://lkml.org/lkml/2009/1/2/360 - but I don't know if that one has been 
> > merged anywhere yet.
> 
> i've applied yours to tip/core/urgent, thanks Jesper!

The same cleanup is in tip/core/iommu:

http://marc.info/?l=linux-kernel&m=123044446721529&w=2


My cleanup patches in it are trivial, but I like to see Becky's
swiotlb highmem work, which is still in tip/core/iommu. When do you
plan to push it to mainline?
