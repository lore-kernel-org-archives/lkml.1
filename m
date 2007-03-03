Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbXCCVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbXCCVBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932395AbXCCVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:01:10 -0500
Received: from mail.tmr.com ([64.65.253.246]:56745 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbXCCVBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:01:09 -0500
Message-ID: <45E9E27A.5010403@tmr.com>
Date: Sat, 03 Mar 2007 16:02:50 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: hjk@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Question: 20 microseconds delay
References: <45E98415.000002.30135@webmail9.yandex.ru> <200703031533.42152.hjk@linutronix.de> <45E98A79.000001.09982@colgate.yandex.ru>
In-Reply-To: <45E98A79.000001.09982@colgate.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> The problem is that I need to use wait_event_timeout function 

AFAIK you can't do that, it's just not the right tool for the job. You 
can always use a single jiffy and be sure you will wait at least 20us, 
or use usleep.

No matter how much you "need to use" your snowblower, it won't mow your 
lawn.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
