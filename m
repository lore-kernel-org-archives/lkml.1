Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbXKBPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbXKBPnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbXKBPnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:43:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60125 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758874AbXKBPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:43:31 -0400
Date: Fri, 2 Nov 2007 11:42:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, 12o3l@tiscali.nl
Subject: Re: build failure, missing libvdeplug.h?
Message-ID: <20071102154254.GA5760@c2.user-mode-linux.org>
References: <2061698400@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2061698400@web.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 01:05:59PM +0100, devzero@web.de wrote:
> I tried 2.6.24-rc1-git11 with "allmodconfig ARCH=um" today.
> 
> this gave at least two errors - i needed to set CONFIG_SMP=n 

SMP should depend on BROKEN for now, and I thought it did.

> and CONFIG_UML_NET_VDE=n to make it compile.

For this, my immediate reaction is that if you're going to build
something, the dependencies should be there.  However, I guess we
should have some sympathy for the automatic allyesconfig builders.
I'm wondering whether, instead of failing the build if headers or
libraries aren't available, compile in some sort of stub which will
produce a run-time error instead.

The violates my preference to have error detected as early as
possible, but maybe it's preferable to the current situation.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
