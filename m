Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZELPcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZELPcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZELPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:32:09 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:35124 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZELPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:32:06 -0400
Message-ID: <4A099670.5060902@nortel.com>
Date: Tue, 12 May 2009 09:32:00 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jussi Laako <jussi@sonarnerd.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       d.faggioli@sssup.it
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net> <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net>
In-Reply-To: <4A094707.5040307@sonarnerd.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2009 15:32:04.0064 (UTC) FILETIME=[CD1B7600:01C9D316]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> Peter Zijlstra wrote:
> 
>>As to the patch, I still think its an exceedingly bad idea to create
>>such a horridly ill defined scheduler class. There's nothing that keeps
>>people from stuffing everything in there and either generating DoS
>>issues or still generating bad interactivity.
> 
> 
> Lite patch practically exports nice levels as scheduling priorities in
> order to make it possible to assign different levels to different
> threads of the same process.

If all you're trying to do is allow different threads to run at
different nice levels, what about extending sys_setpriority() to take a
"which" of PRIO_THREAD?  We'd probably have to call the syscall directly
until/unless libc picks up the new option.

Chris
