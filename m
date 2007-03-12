Return-Path: <linux-kernel-owner+w=401wt.eu-S965363AbXCLIo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbXCLIo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXCLIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:44:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:43863 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965363AbXCLIo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:44:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18xeZIcHQMxYdPO4oEWAsL+kbv7yCqu4ehKrJatOl
	edcriaN4YpfTGt
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703121848.44714.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <20070311121038.GA9146@elte.hu>
	 <1173684174.6659.13.camel@Homer.simpson.net>
	 <200703121848.44714.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 09:44:46 +0100
Message-Id: <1173689086.6748.13.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 18:48 +1100, Con Kolivas wrote:
> 
> Just a couple of questions;
> 
> The X/Gforce case; do they alternate cpu between them? By that I mean when 
> they're the only thing running does the cpu load summate to 1 or does it 
> summate to 2?

They're each on their own cpu (sibling).  Oh, you mean does one wake the
other?  If so, yeah, I believe so.  I instrumented wakeups a (long)
while back, looking into keeping heavy cpu visualizations smooth, and
iirc, X was waking it.

> Gforce presumably is a 3d visualisation? Do you use one of the graphics card 
> drivers listed that uses yield?

No, GL/DRI here.  I'm using a Radeon X850Pro (R480), and for GL/DRI I'd
have to load the proprietary driver.

	-Mike



