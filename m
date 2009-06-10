Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZFJBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZFJBHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZFJBHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:07:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62543 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZFJBHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:07:08 -0400
Message-ID: <4A2F06DC.8040600@cn.fujitsu.com>
Date: Wed, 10 Jun 2009 09:05:32 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [RFC] IO scheduler based IO controller V4
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <4A2DE381.6090205@cn.fujitsu.com> <20090609135256.GA13476@redhat.com>
In-Reply-To: <20090609135256.GA13476@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Tue, Jun 09, 2009 at 12:22:25PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> Hi All,
>>>
>>> Here is the V4 of the IO controller patches generated on top of 2.6.30-rc8.
>>>
>> Hi Vivek,
>>
>> I can't apply the patchset.
>>
>> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/1.eml
>> Applying io-controller: Documentation
>> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/2.eml
>> Applying io-controller: Common flat fair queuing code in elevaotor layer
>> error: patch failed: block/Makefile:15
>> error: block/Makefile: patch does not apply
>> Patch failed at 0001.
>> When you have resolved this problem run "git-am --resolved".
>> If you would prefer to skip this patch, instead run "git-am --skip".
> 
> Hi Gui,
> 
> This is strange. It seems to be applying cleanly for me. Can you please
> recheck your setup and also see why it is failing. In block/Makefile,
> there is one line change and recently no change has taken to that file
> in git.

Hi Vivek，

I guess this patchset is still on top of 2.6.30-rc7 rather than rc8...
I can apply it against rc7 cleanly.


-- 
Regards
Gui Jianfeng

