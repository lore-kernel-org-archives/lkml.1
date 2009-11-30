Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZK3JzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZK3JzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZK3JzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:55:01 -0500
Received: from lazybastard.de ([212.112.238.170]:50908 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZK3JzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:55:00 -0500
Date: Mon, 30 Nov 2009 10:54:51 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses and panics
Message-ID: <20091130095451.GA15335@logfs.org>
References: <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain> <20091013151751.59e217a7@marrow.netinsight.se> <20091013152235.188059d2@marrow.netinsight.se> <20091126093657.GA25430@logfs.org> <1259566071.7518.48.camel@localhost> <20091130074603.GA30911@logfs.org> <1259571118.7518.56.camel@localhost> <20091130093541.GA14254@logfs.org> <1259574055.7518.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259574055.7518.80.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 November 2009 11:40:55 +0200, Artem Bityutskiy wrote:
> 
> The other alternative I was thinking about was to introduce a boolean
> flag, and set it to one as soon as 'lon_end' becomes larger than
> 'log_buf_len'.

I've thought about that as well.  The drawback is that we would have to
check in the regular printk path - by the time the panic notifier is
running it is too late.  So it adds cost to the regular case.

Jörn

-- 
There are three principal ways to lose money: wine, women, and engineers.
While the first two are more pleasant, the third is by far the more certain.
-- Baron Rothschild
