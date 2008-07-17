Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYGQBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYGQBa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 21:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYGQBaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 21:30:17 -0400
Received: from mo32.po.2iij.NET ([210.128.50.17]:18164 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYGQBaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 21:30:15 -0400
Message-Id: <200807170129.m6H1TXgJ008427@po-mbox300.hop.2iij.net>
Date: Thu, 17 Jul 2008 10:31:03 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove old broken Cobalt LCD driver
In-Reply-To: <20080716171818.0e6a45b1.akpm@linux-foundation.org>
References: <20080715223132.e2d217e8.yoichi_yuasa@tripeaks.co.jp>
	<20080716171640.4e1ae418.akpm@linux-foundation.org>
	<20080716171818.0e6a45b1.akpm@linux-foundation.org>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 17:18:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 16 Jul 2008 17:16:40 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 15 Jul 2008 22:31:32 +0900
> > Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:
> > 
> > > Remove old broken Cobalt LCD driver.
> > > 
> > > Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> > 
> > Why do we remove it, rather than unbreaking it?
> > 
> > Did some other driver replace it?  Does nobody need the driver any
> > more?
> 
> doh.  That's what I get for processing patches in reverse-time-order.
> 
> So there's no point in retaining both the old driver and the new one
> for some period of time?

The old driver was not maintained for a long time and
did not work(also it was not used).

It was there for someone might fix it.

But all function(LED, MTD, Framebuffer) replced by new drivers.
It's time to go.

Yoichi
