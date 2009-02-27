Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZB0HDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZB0HDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZB0HDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:03:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZB0HDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:03:42 -0500
Message-ID: <49A79059.4080804@cn.fujitsu.com>
Date: Fri, 27 Feb 2009 15:03:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kenchen@google.com, "menage@google.com" <menage@google.com>,
       mingo@elte.hu, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] change cpuacct usage percpu format
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com> <20090227063955.GS11421@balbir.in.ibm.com> <20090227155517.9283641b.kamezawa.hiroyu@jp.fujitsu.com> <20090227070148.GU11421@balbir.in.ibm.com>
In-Reply-To: <20090227070148.GU11421@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hmm, like this ?
>> ==
>> seq_printf(m, "%d: %llu\n", i, (unsigned long long) percpu);
>> or
>> seq_printf(m, "%d\t: %llu\n", i, (unsigned long long) percpu);
>> ==
>>
>>
> 
> I'd like to see : and not space after it so something like
> 
> seq_printf(m, "%d:%llu\n", i, (unsigned long long) percpu);

I vote for this. :)


