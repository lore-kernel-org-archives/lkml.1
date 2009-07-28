Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZG1Lh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZG1Lh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZG1Lh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:37:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61987 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZG1Lh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:37:56 -0400
Message-ID: <4A6EE2BF.9040803@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 19:36:31 +0800
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
Subject: Re: [RFC] IO scheduler based IO controller V6
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A6D0C9A.3080600@cn.fujitsu.com> <20090727125503.GA24449@redhat.com>
In-Reply-To: <20090727125503.GA24449@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Jul 27, 2009 at 10:10:34AM +0800, Gui Jianfeng wrote:
>> Hi，
>>
>> Here are some fio test results for IO Controller V6 built and not built.
>> Iozone test results are also attached.
>>
> 
> Hi Gui,
> 
> Thanks a lot for some performance numbers. It seems to be a mixed chart.
> Performance gains at some places and loss at others. I am curious about
> that -7.0% for normal writes. Not sure what can contribute to that.
> 
> What was the value of "fairness" parameter when you ran those tests? Can you
> please set fairness = 0 and re-run the tests (if you have already not done so).
> 
> By default fairness is set to 1 in V6. With fairness = 0, we should be very
> close to existing CFQ behavior. If not, then we need to dive deeper and
> see why variations are happening.

  Hi Vivek,

  I tested with default fairness value, i'll re-test it when fairness is set to 0.

> 
> Is it also possible to run the same tests with V7. 

  Sure.

-- 
Regards
Gui Jianfeng

