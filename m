Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZEMLdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZEMLdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZEMLcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:32:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366AbZEMLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:32:55 -0400
Date: Wed, 13 May 2009 13:38:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Message-ID: <20090513113817.GO19296@one.firstfloor.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com> <87r5ytl0nn.fsf@basil.nowhere.org> <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In past days, I proposed this. but Minchan found this config bloat kernel 7kb
> and he claim embedded guys should have selectable chance. I agreed it.

Well there's lots of code in the kernel and 7k doesn't seem worth bothering.
If you just save two pages of memory somewhere you can save more.

> Is this enough explanation?

It's not a very good one.

I would propose to just remove it or at least hide it completely
and only make it dependent on CONFIG_MMU inside Kconfig.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
