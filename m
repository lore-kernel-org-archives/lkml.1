Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXEYQpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXEYQpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbXEYQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:45:16 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:48953 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762064AbXEYQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:45:14 -0400
Message-ID: <4657128F.7000600@linux.vnet.ibm.com>
Date: Fri, 25 May 2007 22:15:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <20070525124652.GA24038@elte.hu>
In-Reply-To: <20070525124652.GA24038@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i found an accounting bug in this: it didnt sum up threads correctly. 
> The patch below fixes this. The stime == 0 problem is still there 
> though.
> 
> 	Ingo
> 

Thanks! I'll test the code on Monday. I do not understand the
sysctl_sched_smoothing functionality, so I do not understand
its impact on accounting. I'll take a look more closely

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
