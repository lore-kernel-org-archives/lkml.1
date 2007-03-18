Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXCRIWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXCRIWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXCRIWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:22:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59601 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbXCRIWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:22:52 -0400
Date: Sun, 18 Mar 2007 00:22:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bias the location of pages freed for min_free_kbytes in
 the same MAX_ORDER_NR_PAGES blocks
Message-Id: <20070318002244.606cfe08.akpm@linux-foundation.org>
In-Reply-To: <20070317182641.GA19447@skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
	<200703142006.04547.m.kozlowski@tuxland.pl>
	<20070314170738.d5d35c06.akpm@linux-foundation.org>
	<20070317182641.GA19447@skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007 18:26:41 +0000 mel@skynet.ie (Mel Gorman) wrote:
>

I still haven't got onto reviewing all your mm patches :(   Nor has anyone
else, afaik.

But let me leap ahead of myself.

> CONFIG_PAGE_GROUP_BY_MOBILITY

Why does this config item exist?  It's not good to have some mysterious
knob which affects mm behaviour at compile time.  We need to make up our
minds and stick with it.

