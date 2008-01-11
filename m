Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYAKB0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYAKB0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 20:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYAKB0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 20:26:34 -0500
Received: from mail.tmr.com ([64.65.253.246]:42508 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbYAKB0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 20:26:33 -0500
Message-ID: <4786CB57.9060000@tmr.com>
Date: Thu, 10 Jan 2008 20:50:15 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: righiandr@users.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net>
In-Reply-To: <47869FFE.1050000@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> Allow to limit the bandwidth of I/O-intensive processes, like backup
> tools running in background, large files copy, checksums on huge files,
> etc.
> 
> This kind of processes can noticeably impact the system responsiveness
> for some time and playing with tasks' priority is not always an
> acceptable solution.
> 
> This patch allows to specify a maximum I/O rate in sectors per second
> for each single process via /proc/<PID>/io_throttle (default is zero,
> that specify no limit).
> 
It would seem to me that this would be vastly more useful in the real 
world if there were a settable default, so that administrators could 
avoid having to find and tune individual user processes. And it would 
seem far less common that the admin would want to set the limit *up* for 
a given process, and it's likely to be one known to the admin, at least 
by name.

Of course if you want to do the effort to make it fully tunable, it 
could have a default by UID or GID. Usful on machines shared by students 
or managers.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
