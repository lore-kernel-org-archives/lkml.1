Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbXA2Pnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbXA2Pnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXA2Pnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:43:35 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:56139 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbXA2Pne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:43:34 -0500
Message-ID: <45BE161A.2000504@cfl.rr.com>
Date: Mon, 29 Jan 2007 10:43:22 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
CC: Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linus Torvalds <torvalds@osdl.org>, Viktor <vvp01@inbox.ru>,
       Aubrey <aubreylee@gmail.com>, Hua Zhong <hzhong@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com>
In-Reply-To: <200701281803.08201.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2007 15:43:38.0953 (UTC) FILETIME=[3EC79B90:01C743BC]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14964.003
X-TM-AS-Result: No--1.365200-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> I still don't see much difference between O_SYNC and O_DIRECT write
> semantic.

Yes, if you change the normal io paths to properly support playing 
vmsplice games ( which have a number of corner cases ) to get the zero 
copy, and support madvise() and O_SYNC to control caching behavior, and 
fix all the error handling corner cases, then you may be able to do away 
with O_DIRECT.

I believe that doing all that will be much more complex than O_DIRECT 
however.

