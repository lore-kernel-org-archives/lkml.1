Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZDNGX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZDNGX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZDNGXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:23:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZDNGXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:23:14 -0400
Message-ID: <49E42C04.3020304@cn.fujitsu.com>
Date: Tue, 14 Apr 2009 14:24:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/filters: allow user-input to be integer-like
 string
References: <49E2A594.4060306@cn.fujitsu.com>	 <20090413144513.GF5977@nowhere>  <20090413222951.GG8514@elte.hu> <1239682887.7011.54.camel@tropicana>
In-Reply-To: <1239682887.7011.54.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This also conflicts with Tom's rewrite of the filter engine to make 
>> it on-the-fly modifiable.
>>
>> Li, mind reworking your series against latest -tip? (it has Tom's 
>> patch included already)
>>
>> Also, it would be nice to hear Tom's opinion about this series as 
>> well. I know there's new parsing features planned - if it's better 
>> that way then Tom you might want to pick up Li's patches and submit 
>> them together with any pending or upcoming changes? We can apply 
>> them directly too if that's easier to you.
>>
> 
> I had started on the new parser a couple weeks ago, but got sidetracked
> by other things.  I'll be getting back to it this week, but until it's
> ready it wouldn't hurt for you to pick up Li's patches, and I'll make
> any changes I need to in the new code.
> 

Ok, I'll rebase those patches and send to Ingo.

> What this patch does will be needed by the new code too, so it would be
> good to have it, though it might get moved around.  Patch 2 won't hurt
> either, though everything in filter_parse() will probably change.  And
> patch 3 fixes a bug that needs to be fixed regardless...
> 
