Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbXDHICN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbXDHICN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 04:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXDHICN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 04:02:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:41269 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752741AbXDHICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 04:02:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+IdBArX1eIKNOZ/C35NQzJLcuWdabt7T3XOdc+vL
	MAA9f02rJuNmGn
Subject: Re: SD scheduler testing hitch
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>
In-Reply-To: <1175966255.11408.5.camel@Homer.simpson.net>
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
	 <b647ffbd0704041305t2a140369q56cf9f0746b8fd86@mail.gmail.com>
	 <20070406170319.2c961eba.akpm@linux-foundation.org>
	 <20070407092401.GB16356@elte.hu>
	 <1175962840.10478.49.camel@Homer.simpson.net>
	 <1175966255.11408.5.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 08 Apr 2007 10:02:04 +0200
Message-Id: <1176019324.8244.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 19:17 +0200, Mike Galbraith wrote:

> I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
> here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
> starving 10% duty cycle task has trouble getting 1% CPU.

Hmm.  Playing with it some more today, it still happens, but it's not
very repeatable.  Something is odd.  I wonder if any SD using readers
will try it.

	-Mike

