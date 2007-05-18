Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbXERVyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbXERVyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbXERVy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:54:26 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:56300 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754995AbXERVyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:54:25 -0400
Message-ID: <464E2098.8020900@cfl.rr.com>
Date: Fri, 18 May 2007 17:54:32 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alex Volkov <avcp-lkmail@usa.net>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: aio is unlikely
References: <20070509151831.f5956b66.akpm@linux-foundation.org> <058f01c7998e$1406e370$650df7cd@MUMBA> <20070518140624.1a4db517.akpm@linux-foundation.org>
In-Reply-To: <20070518140624.1a4db517.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 May 2007 21:54:41.0045 (UTC) FILETIME=[230C0450:01C79997]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15184.001
X-TM-AS-Result: No--5.468600-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yes, if you agree with Jeff's original point.
> 
> But I don't, actually.  Sure, on some machines+workloads, AIO is more
> common than sync IO.  But I expect that when we sum across all the
> machines+workloads in the world, sync IO is more common and is hence the
> case we should optimise for.
> 
> That's assuming that the unlikely() actually does something.

But as Jeff said, that's not what unlikely is for.  It should only be 
used when it is unlikely for everybody, all the time, because when it is 
right, it helps rather little, but when it is wrong, it hurts a lot.

