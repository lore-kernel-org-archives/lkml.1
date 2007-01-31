Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXAaJh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXAaJh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932861AbXAaJh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:37:28 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21709 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbXAaJh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:37:26 -0500
Message-ID: <45C06351.4070704@tls.msk.ru>
Date: Wed, 31 Jan 2007 12:37:21 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Phillip Susi <psusi@cfl.rr.com>
CC: Andrea Arcangeli <andrea@suse.de>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Bill Davidsen <davidsen@tmr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com> <20070129170056.GJ8030@opteron.random> <45BE7D99.70200@cfl.rr.com> <20070130023056.GN8030@opteron.random> <45BF65E3.6070102@cfl.rr.com> <20070130164806.GQ8030@opteron.random> <45BF9381.8010108@cfl.rr.com> <20070130195720.GR8030@opteron.random> <45BFCFA2.6000701@cfl.rr.com>
In-Reply-To: <45BFCFA2.6000701@cfl.rr.com>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
[]
> You seem to have missed the point of this thread.  Denis Vlasenko's
> message that you replied to simply pointed out that they are
> semantically equivalent, so O_DIRECT can be dropped provided that O_SYNC
> + madvise could be fixed to perform as well.  Several people including
> Linus seem to like this idea and think it is quite possible.

By the way, IF O_SYNC+madvise could be "fixed", can't O_DIRECT be implemented
internally using them?

I mean, during open(O_DIRECT), do open(O_SYNC) instead and call madvise()
appropriately....

/mjt
