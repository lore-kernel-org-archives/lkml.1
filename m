Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbXJVKOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbXJVKOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXJVKOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:14:34 -0400
Received: from smtp.nokia.com ([131.228.20.171]:19881 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXJVKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:14:33 -0400
Message-ID: <471C75AB.8010608@yandex.ru>
Date: Mon, 22 Oct 2007 13:04:27 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcing write-back from FS - again
References: <471BB45D.8070509@nokia.com>        <20071021135526.57db7519.akpm@linux-foundation.org>        <471C64D1.3020904@yandex.ru>        <20071022020559.aa3fc59c.akpm@linux-foundation.org>        <471C6FA8.30500@yandex.ru> <20071022025516.848198f3.akpm@linux-foundation.org>
In-Reply-To: <20071022025516.848198f3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Oct 2007 10:04:27.0609 (UTC) FILETIME=[EE507490:01C81492]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> take a look at struct writeback_control:
> 
>         unsigned nonblocking:1;         /* Don't get stuck on request queues */
>         unsigned encountered_congestion:1; /* An output: a queue is full */
>         unsigned for_kupdate:1;         /* A kupdate writeback */
>         unsigned for_reclaim:1;         /* Invoked from the page allocator */
>         unsigned for_writepages:1;      /* This is a writepages() call */
>         unsigned range_cyclic:1;        /* range_start is cyclic */
>         unsigned more_io:1;             /* more io to be dispatched */
> 
> Add another one...

Ups, OK! Thanks again!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
