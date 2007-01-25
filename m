Return-Path: <linux-kernel-owner+w=401wt.eu-S1030549AbXAYUDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549AbXAYUDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 15:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030551AbXAYUDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 15:03:45 -0500
Received: from iriserv.iradimed.com ([69.44.168.233]:17744 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030549AbXAYUDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 15:03:45 -0500
Message-ID: <45B90D19.60106@cfl.rr.com>
Date: Thu, 25 Jan 2007 15:03:37 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Denis Vlasenko <vda.linux@googlemail.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
Subject: Re: O_DIRECT question
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701251838.30796.vda.linux@googlemail.com> <45B904CF.1070102@cfl.rr.com> <200701252052.38119.vda.linux@googlemail.com>
In-Reply-To: <200701252052.38119.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2007 20:03:58.0298 (UTC) FILETIME=[F2FB83A0:01C740BB]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-14956.003
X-TM-AS-Result: No--3.530800-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> You mean "You can use aio_write" ?

Exactly.  You generally don't use O_DIRECT without aio.  Combining the 
two is what gives the big win.

