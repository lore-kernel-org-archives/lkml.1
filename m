Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXCPPOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXCPPOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965381AbXCPPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:14:44 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:40693 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXCPPOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:14:44 -0400
Message-ID: <45FAB458.2080304@nortel.com>
Date: Fri, 16 Mar 2007 09:14:32 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RSDL-mm 4/6] sched: dont renice kernel threads
References: <200703170054.08641.kernel@kolivas.org>
In-Reply-To: <200703170054.08641.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 15:14:35.0901 (UTC) FILETIME=[CED77AD0:01C767DD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> The practice of renicing kernel threads to negative nice values is of
> questionable benefit at best, and at worst leads to larger latencies when
> kernel threads are busy on behalf of other tasks.

What about the priority implications of the renicing?  It seems a bit 
iffy letting kernel threads compete for cpu time on an equal basis with 
your default shell.

Chris
