Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYDLUwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYDLUwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYDLUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:52:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYDLUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:52:05 -0400
Message-ID: <48012002.8030701@zytor.com>
Date: Sat, 12 Apr 2008 13:48:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Erik Bosman <ebn310@few.vu.nl>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <20080412124947.146865e4@laptopd505.fenrus.org>
In-Reply-To: <20080412124947.146865e4@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> Hi,
> 
> why did you make this a configuration option? In general it's not
> a good idea to make userspace visible ABI's (PR_* clearly is one of these)
> a CONFIG option unless there's some HUGE space saving going on.
> I don't see that here....
> 
> So can you explain your rationale for making this a config option?
> 

I also saw no mention about performance impact, which need to be 
considered whenever *anything* is proposed to be inserted into a hot 
path.  It may be (heck, *should be*) that the performance impact isn't 
measurable, but that needs to be positively established.

	-hpa
