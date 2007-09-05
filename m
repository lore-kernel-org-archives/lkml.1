Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXIEWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXIEWtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 18:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbXIEWsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:48:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXIEWsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:48:54 -0400
Message-ID: <46DF3253.6030007@redhat.com>
Date: Wed, 05 Sep 2007 18:48:51 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.22: what IS the VM doing?
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi> <46DE085F.2040306@redhat.com> <20070905114545.2hydqpasqx56afkf@m.safari.iki.fi> <46DED83A.8070104@redhat.com> <20070905173332.dzwkm5ofdvtjcal4@m.safari.iki.fi>
In-Reply-To: <20070905173332.dzwkm5ofdvtjcal4@m.safari.iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sami Farin wrote:
> On Wed, Sep 05, 2007 at 12:24:26 -0400, Rik van Riel wrote:
> ...
>>> *shrug*
>> The attached patch should make sure kswapd does not free an
>> excessive number of pages in zone_normal just because the
>> pages in zone_highmem are difficult to free.
>>
>> It does give kswapd a large margin to continue putting equal
>> pressure on all zones in normal situations.
>>
>> Sami, could you try out this patch to see if it helps your
>> situation?
> 
> Thanks, Rik.  bzImage is ready, I probably reboot inside one
> month for a reason or other 8-)

The more I look at the bug, the more I see that it is probably
not very easy to reproduce on demand.  I have, however, a full
explanation on why it happens and why the patch should fix it,
so I will submit it for inclusion in -mm.

Sami, thank you for the detailed bug report.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
