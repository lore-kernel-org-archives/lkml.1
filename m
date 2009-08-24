Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbZHXCEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbZHXCEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZHXCEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZHXCEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:04:08 -0400
Message-ID: <4A91F57D.10708@redhat.com>
Date: Mon, 24 Aug 2009 10:05:49 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, nhorman@redhat.com,
       ebiederm@xmission.com, andi@firstfloor.org, bernhard.walle@gmx.de,
       fenghua.yu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
       avorontsov@ru.mvista.com
Subject: Re: [Patch 5/8] ia64: implement crashkernel=auto
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain> <20090821065729.4855.47860.sendpatchset@localhost.localdomain> <20090821172407.d3a5cd2b.akpm@linux-foundation.org> <20090822111816.GA12281@elte.hu>
In-Reply-To: <20090822111816.GA12281@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> e) All the 'else' statements are superflous and make it all harder 
>    to read.
>
> f) 2ULL<<30 should be written as 1ULL<31, to keep things consistent.
>   

Hi,

The reason that I kept 2ULL<<30 instead of 1ULL<<31 is that '1<<30' is 
exactly 1G, so 2ULL<<30 can be easily read as 2G. ;)

> g) A nice comment explaining the purpose and logic wouldnt hurt.
>   

Yup, in fact patch 8/8 has the doc for this, but I will copy that here 
as a comment too.

Thanks!

