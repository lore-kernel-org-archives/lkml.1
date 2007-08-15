Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXHOIEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXHOIEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbXHOIED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:04:03 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:43973 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXHOID7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:03:59 -0400
Message-ID: <46C2B35B.5080709@alcatel-lucent.com>
Date: Wed, 15 Aug 2007 16:03:39 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Bernd Eckenfels <ecki@lina.inka.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: do_coredump and O_NOFOLLOW
References: <E1ILCwJ-0003th-00@calista.eckenfels.net>
In-Reply-To: <E1ILCwJ-0003th-00@calista.eckenfels.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 08:03:47.0487 (UTC) FILETIME=[CEC682F0:01C7DF12]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> In article <46C290F6.2090309@alcatel-lucent.com> you wrote:
>   
>> I found that O_NOFOLLOW is used for opened core file in Linux 2.6.10. 
>>     
>
> I think that is for security reasons, otherwise one has to (atomically)
> check who is the owner of the symlink and where it points to. If you dont
> have hostile users on your system you might be able to remove it, but it is
> not a good idea in the general public.
>
> Maybe we need a coreadm tool like Solaris has, where you can put the
> corefiles where you want. That would change the corepattern to include a
> path and be specific to a process (tree).
>
> Gruss
> Bernd
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Bernd, Thanks for your reply. I don't think there are any hostile users 
on the system. So it's relatively of security. I didn't hear of coreadm 
tool before, Linux will become more powerful with coreadm.
