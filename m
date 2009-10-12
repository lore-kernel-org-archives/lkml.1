Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZJLNIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZJLNIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZJLNIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:08:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53660 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541AbZJLNIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:08:10 -0400
Date: Mon, 12 Oct 2009 14:08:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012140821.5dfa1598@lxorguk.ukuu.org.uk>
In-Reply-To: <20091012123210.GB22766@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	<20091012111545.GB8857@elte.hu>
	<1255346731.9659.31.camel@localhost>
	<20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<20091012142714.56362465@marrow.netinsight.se>
	<20091012123210.GB22766@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> See my reply to David Woodhouse, i think we should add support for 
> buffering in kernel/printk.c and that would both fix your problems, 
> would simplify the driver (significantly!) and would expose the generic 
> buffering capability to other console drivers as well.

Buffering printk in general is bad. Given a driver needs only to provide
about 6 lines of code using a kfifo is it really that hard for the odd
code that wants to buffer to do that ?

