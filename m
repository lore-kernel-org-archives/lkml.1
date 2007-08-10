Return-Path: <linux-kernel-owner+w=401wt.eu-S941494AbXHJQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941494AbXHJQr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938650AbXHJQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:47:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:37571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S937799AbXHJQrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:47:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+jlhcxdnejMpsbagaDv7TdHjIyGaYDPyslMGMrWK
	10rYNCjAad92U8
Subject: Re: CFS review
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708101459530.1817@scrub.home>
References: <Pine.LNX.4.64.0708010439050.1817@scrub.home>
	 <20070801071230.GA16375@elte.hu>
	 <Pine.LNX.4.64.0708011511530.1817@scrub.home>
	 <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de>
	 <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
	 <20070801175004.GA17936@elte.hu>
	 <Pine.LNX.4.64.0708011955430.1817@scrub.home>
	 <20070801190556.GA1199@elte.hu>
	 <Pine.LNX.4.64.0708100037460.1817@scrub.home>
	 <20070810054948.GA5908@elte.hu>
	 <Pine.LNX.4.64.0708101459530.1817@scrub.home>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 18:47:17 +0200
Message-Id: <1186764437.6397.15.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I guess I'm going to have to give up on trying to reproduce this... my
3GHz P4 is just not getting there from here.  Last attempt, compiled UP,
HZ=1000 dynticks, full preempt and highres timers fwiw.

6392 root      20   0  1696  332  248 R 25.5  0.0   3:00.14 0 lt
6393 root      20   0  1696  332  248 R 24.9  0.0   3:00.15 0 lt
6391 root      20   0  1696  488  404 R 24.7  0.0   3:00.20 0 lt
6394 root      20   0  2888 1232 1028 R 24.5  0.1   2:58.58 0 sh

	-Mike

