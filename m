Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbXL2IOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbXL2IOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXL2IOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:14:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45416
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbXL2ION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:14:13 -0500
Date: Sat, 29 Dec 2007 00:14:11 -0800 (PST)
Message-Id: <20071229.001411.210630819.davem@davemloft.net>
To: bunk@kernel.org
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071228232255.GB9105@does.not.exist>
References: <200712261329.08313.m.kozlowski@tuxland.pl>
	<20071226.190504.20990618.davem@davemloft.net>
	<20071228232255.GB9105@does.not.exist>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sat, 29 Dec 2007 01:22:56 +0200

> At least the sunserial_console_match() one is an obvious Oops 
> (EXPORT_SYMBOL of an __init function).
> 
> The comment in the description of
> commit 58d784a5c754cd66ecd4791222162504d3c16c74 the warning was bogus    
> is bullshit.
> 
> I'm not sure whether this might count as a 2.6.24-rc regression or 
> whether 2.6.23 is simply differently but similarly broken (does anyone 
> actually use the Sun console drivers modular?).

You can't do that, the FOO_CONSOLE config options depend upon
FOO=y.

That's why I'm not worried about this issue and it's not critical at
all.
