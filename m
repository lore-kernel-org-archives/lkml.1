Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYLVXau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYLVXau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYLVXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:30:37 -0500
Received: from mailbackup.inode.at ([213.229.60.24]:40425 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbYLVXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:30:35 -0500
Message-ID: <495022D6.3050703@sbg.ac.at>
Date: Tue, 23 Dec 2008 00:29:26 +0100
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jarek Poplawski <jarkao2@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [Bug #12261] kernel panics with net_rx_action on kernels above
 2.6.26
References: <_EB9bLpq_z.A.hAC.NkYTJB@chimera> <CMMRhk39O-L.A.tMC.TkYTJB@chimera> <20081222072614.GB2631@ff.dom.local> <200812222126.41727.rjw@sisk.pl>
In-Reply-To: <200812222126.41727.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 22 of December 2008, Jarek Poplawski wrote:
>   
>> On Sat, Dec 20, 2008 at 11:16:15PM +0100, Rafael J. Wysocki wrote:
>>     
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.26 and 2.6.27.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12261
>>> Subject		: kernel panics with net_rx_action on kernels above 2.6.26
>>> Submitter	: Alexander Huemer <alexander.huemer@sbg.ac.at>
>>> Date		: 2008-12-13 18:43 (8 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=122919424932016&w=4
>>> Handled-By	: Jarek Poplawski <jarkao2@gmail.com>
>>> Patch		: http://marc.info/?l=linux-net&m=122934825227768&w=4
>>>
>>>
>>>       
>> It's fixed in the mainline:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9a3de25544dadab1971847f28f33b1cd0d1770a6
>>
>> But stables need this too:
>> - 2.6.27 - always
>> - 2.6.26, 2.6.25 (...?) for CONFIG_ADAPTEC_STARFIRE_NAPI
>>     
>
> Thanks, I've just pushed inclusion request to -stable.
>
> Rafael
>   
thanks you for your help, guys.
the problem id definitely fixed with this patch.

-- 
kind regards
alex
