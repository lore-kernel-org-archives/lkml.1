Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbXGODnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbXGODnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 23:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXGODnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 23:43:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34644
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbXGODnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 23:43:12 -0400
Date: Sat, 14 Jul 2007 20:43:14 -0700 (PDT)
Message-Id: <20070714.204314.70218766.davem@davemloft.net>
To: acahalan@gmail.com
Cc: olaf@aepfle.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
From: David Miller <davem@davemloft.net>
In-Reply-To: <787b0d920707141948t71b4059s7ae68610f9f81eac@mail.gmail.com>
References: <787b0d920707141948t71b4059s7ae68610f9f81eac@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Albert Cahalan" <acahalan@gmail.com>
Date: Sat, 14 Jul 2007 22:48:57 -0400

> A real constant-value PAGE_SIZE is useful and doable.

It's bogus to use it.  The kernel can get recompiled
to arbitrary page sizes on some architectures, so a constat
page size assumption cannot work.

> It's useful because a getpagesize() can't be used for numerous
> things, such as setting the size of an array.

Use dynamically allocated memory for the array then.

This isn't programming 101.
