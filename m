Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbYJNOef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbYJNOef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYJNOeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:34:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbYJNOeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:34:24 -0400
Date: Tue, 14 Oct 2008 07:30:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: madhu.cr@ti.com, gadiyar@ti.com, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] HDQ Driver for OMAP2430/3430
Message-Id: <20081014073058.e5d972e6.akpm@linux-foundation.org>
In-Reply-To: <20081014134249.GA5611@2ka.mipt.ru>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF0@dbde02.ent.ti.com>
	<20081010133845.8b82fac3.akpm@linux-foundation.org>
	<062801c92d37$3413bdd0$LocalHost@wipultra1303>
	<20081013085323.f8bd7efb.akpm@linux-foundation.org>
	<015c01c92dda$1b754340$LocalHost@wipultra1303>
	<20081014055002.24ff586a.akpm@linux-foundation.org>
	<20081014134249.GA5611@2ka.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 14 Oct 2008 17:42:49 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
> 
> On Tue, Oct 14, 2008 at 05:50:02AM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
> > I think it's reasonable to permit the driver's operations to be interrupted
> > in this manner.  It's done in quite a few other places.  But the problem is
> > actually *testing* it.
> 
> Why not just skipping the waiting and returning error pretending user
> really sent a signal?

Better than nothing, but because signal_pending() isn't actually true,
upper layers wil behave differently.

