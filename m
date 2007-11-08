Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXKHOnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXKHOnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXKHOnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:43:42 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:53393 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbXKHOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:43:42 -0500
Message-ID: <4733206C.8030903@nortel.com>
Date: Thu, 08 Nov 2007 08:42:52 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: David Miller <davem@davemloft.net>, paulus@samba.org,
       akpm@linux-foundation.org, lkml@davidb.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
References: <20071107152833.6f302c2a.akpm@linux-foundation.org> <20071107161853.044b6e8f.akpm@linux-foundation.org> <18226.27701.782268.375231@cargo.ozlabs.ibm.com> <20071107.180918.263752219.davem@davemloft.net> <jetznxt4wu.fsf@sykes.suse.de>
In-Reply-To: <jetznxt4wu.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Nov 2007 14:42:56.0955 (UTC) FILETIME=[A6E210B0:01C82215]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:

> A possible remedy is to return the ticks since process start time, which
> delays the wrap around much further.  POSIX only demands consistency
> within the same process.

This would be an interesting solution.

The man page for linux states that the return code is time since system 
boot, so that could realistically be expected to correlate between 
different processes.

Could we get away with changing the man page and breaking any apps 
relying on this previously-documented behaviour?



Chris
