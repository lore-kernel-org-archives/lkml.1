Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXBLGIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXBLGIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933018AbXBLGIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:08:48 -0500
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:55929 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933012AbXBLGIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:08:47 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: CPU load
Date: Mon, 12 Feb 2007 17:08:14 +1100
User-Agent: KMail/1.9.5
Cc: "Vassili Karpov" <av1474@comtv.ru>, linux-kernel@vger.kernel.org
References: <loom.20070212T063225-663@post.gmane.org> <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com> <20070212165554.42d12419.sfr@canb.auug.org.au>
In-Reply-To: <20070212165554.42d12419.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121708.14915.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 16:55, Stephen Rothwell wrote:
> On Mon, 12 Feb 2007 16:44:22 +1100 "Con Kolivas" <kernel@kolivas.org> wrote:
> > The kernel looks at what is using cpu _only_ during the timer
> > interrupt. Which means if your HZ is 1000 it looks at what is running
> > at precisely the moment those 1000 timer ticks occur. It is
> > theoretically possible using this measurement system to use >99% cpu
> > and record 0 usage if you time your cpu usage properly. It gets even
> > more inaccurate at lower HZ values for the same reason.
>
> That is not true on all architecures, some do more accurate accounting by
> recording the times at user/kernel/interrupt transitions ...

Indeed. It's certainly the way the common more boring pc architectures do it 
though.

-- 
-ck
