Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbXLQE00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbXLQE00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 23:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXLQE0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 23:26:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53353
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbXLQE0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 23:26:14 -0500
Date: Sun, 16 Dec 2007 20:26:11 -0800 (PST)
Message-Id: <20071216.202611.226170474.davem@davemloft.net>
To: mpm@selenic.com
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071217021149.GC19691@waste.org>
References: <200712161948.42656.m.kozlowski@tuxland.pl>
	<200712162010.11028.m.kozlowski@tuxland.pl>
	<20071217021149.GC19691@waste.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>
Date: Sun, 16 Dec 2007 20:11:49 -0600

> But as the function doesn't actually show up in your stack trace,
> something else is probably wrong. So I'd also try commenting out
> pieces of that function until it started working.

Some piece of state is being indirectly corrupted and this
is showing up later in some unrelated operation.

Can someone send me this kpageflags patch under seperate
cover?  I'll try figure out why it farts on sparc64.
