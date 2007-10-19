Return-Path: <linux-kernel-owner+w=401wt.eu-S937272AbXJST7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937272AbXJST7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936588AbXJST6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:58:18 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:53271 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936511AbXJST6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:58:17 -0400
Message-ID: <47190C6C.9020709@cfl.rr.com>
Date: Fri, 19 Oct 2007 15:58:36 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: John Marconi <john.marconi@utstar.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem:  CPU sleep when calling a function in another object
 for the first time.
References: <E9FB75D95739914DBDEDC1867C740F4FD4E64C@ITLHZEXCH01.us.utstar.com>
In-Reply-To: <E9FB75D95739914DBDEDC1867C740F4FD4E64C@ITLHZEXCH01.us.utstar.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2007 19:58:31.0314 (UTC) FILETIME=[6C60F720:01C8128A]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15494.000
X-TM-AS-Result: No--13.390100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Marconi wrote:
> I have added a kernel profiler to the timer interrupt of this CPU - and
> find that during this 40ms period, the CPU is in r4k_wait - which looks
> like cpu_idle is running.  It almost seems like file Y is being loaded
> into memory to be used.

That is exactly what is happening.  Pages in the code segment are only 
loaded on demand.


