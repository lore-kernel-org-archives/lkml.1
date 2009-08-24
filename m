Return-Path: <linux-kernel-owner+w=401wt.eu-S1751085AbZHXHn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085AbZHXHn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZHXHnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:43:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZHXHny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:43:54 -0400
Date: Mon, 24 Aug 2009 09:43:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, nhorman@redhat.com,
       ebiederm@xmission.com, andi@firstfloor.org, bernhard.walle@gmx.de,
       fenghua.yu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
       avorontsov@ru.mvista.com
Subject: Re: [Patch 5/8] ia64: implement crashkernel=auto
Message-ID: <20090824074318.GB2424@elte.hu>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain> <20090821065729.4855.47860.sendpatchset@localhost.localdomain> <20090821172407.d3a5cd2b.akpm@linux-foundation.org> <20090822111816.GA12281@elte.hu> <4A91F57D.10708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A91F57D.10708@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Amerigo Wang <amwang@redhat.com> wrote:

> Ingo Molnar wrote:
>>
>> e) All the 'else' statements are superflous and make it all harder    
>> to read.
>>
>> f) 2ULL<<30 should be written as 1ULL<31, to keep things consistent.
>>   
>
> Hi,
>
> The reason that I kept 2ULL<<30 instead of 1ULL<<31 is that '1<<30' is  
> exactly 1G, so 2ULL<<30 can be easily read as 2G. ;)

i have no trouble reading 1ULL<<31 as 2G ;-) OTOH, the logic and 
pattern of the comparisons (especially without the comment) looked 
odd at first sight, until i noticed this.

	Ingo
