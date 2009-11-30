Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZK3HqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZK3HqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZK3HqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:46:14 -0500
Received: from lazybastard.de ([212.112.238.170]:52180 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbZK3HqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:46:13 -0500
Date: Mon, 30 Nov 2009 08:46:03 +0100
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
Message-ID: <20091130074603.GA30911@logfs.org>
References: <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain> <20091013151751.59e217a7@marrow.netinsight.se> <20091013152235.188059d2@marrow.netinsight.se> <20091126093657.GA25430@logfs.org> <1259566071.7518.48.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259566071.7518.48.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 November 2009 09:27:51 +0200, Artem Bityutskiy wrote:
> 
> To me it looks like 'log_end' is not supposed to wrap. What makes you
> think it can? In which cases it can?

It is a 32bit variable.  Would do you expect happens once you reach
0xffffffff and add 1?

Jörn

-- 
This above all: to thine own self be true.
-- Shakespeare
