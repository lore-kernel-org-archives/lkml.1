Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZLHIuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZLHIuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZLHIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:50:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZLHIuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:50:17 -0500
Message-ID: <4B1E13C8.70704@redhat.com>
Date: Tue, 08 Dec 2009 16:52:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC Patch] getrusage: fill ru_ixrss, ru_idrss and ru_isrss fields
References: <20091208083358.4232.28469.sendpatchset@localhost.localdomain> <20091208173730.B5C3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091208173730.B5C3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> 	The next three fields, the subject of this patch, are named ru_XXrss:
> 	though the 80-column comment omits to say "resident set" before "size",
> 	I believe they'd be expected to account (subdivided) resident set sizes?
> 
> 
> your calculation is not rss nor not integral.
> 

Hmm, I misunderstood rss here. Does it mean the memory stayed in
physical mem? i.e. not swapped out.

So, if I want to get those rss statistics, I have to add some more
mm_counter by myself? I only find file_rss and anon_rss in mm_struct.

Thanks.

