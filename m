Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZHaBKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZHaBKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 21:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZHaBKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 21:10:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZHaBKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 21:10:37 -0400
Message-ID: <4A9B22BF.6010707@cn.fujitsu.com>
Date: Mon, 31 Aug 2009 09:09:19 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: [RFC] IO scheduler based IO controller V9
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi All,
> 
> Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
> 
> For ease of patching, a consolidated patch is available here.
> 
> http://people.redhat.com/~vgoyal/io-controller/io-scheduler-based-io-controller-v9.patch
> 
> Changes from V8
> ===============
> - Implemented bdi like congestion semantics for io group also. Now once an
>   io group gets congested, we don't clear the congestion flag until number
>   of requests goes below nr_congestion_off.
> 
>   This helps in getting rid of Buffered write performance regression we
>   were observing with io controller patches.
> 
>   Gui, can you please test it and see if this version is better in terms
>   of your buffered write tests.

Ok, will do.

-- 
Regards
Gui Jianfeng

