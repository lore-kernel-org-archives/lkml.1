Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZGUTPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZGUTPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZGUTPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:15:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43472
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbZGUTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:15:14 -0400
Date: Tue, 21 Jul 2009 12:15:19 -0700 (PDT)
Message-Id: <20090721.121519.239732131.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090721160538.GL25756@amd.com>
References: <20090714092354.GL19087@amd.com>
	<20090714.131224.205307048.davem@davemloft.net>
	<20090721160538.GL25756@amd.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 21 Jul 2009 18:05:38 +0200

> Hmm these checks sound specific and hard to maintain. I think its best
> to give architectures the option whether to enable this check or not.

No matter how the arch works in this area, there should be some
kind of sanity check.

So, it probably makes sense to allow an arch to override the
validation function rather than turn the test completely off.
