Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZIJRd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZIJRd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZIJRd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbZIJRd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:33:27 -0400
Date: Thu, 10 Sep 2009 13:32:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 15/23] io-controller: noop changes for hierarchical
	fair queuing
Message-ID: <20090910173242.GB29559@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-16-git-send-email-vgoyal@redhat.com> <4A9B3B0B.9090009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B3B0B.9090009@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 10:52:59PM -0400, Rik van Riel wrote:
> Vivek Goyal wrote:
>> This patch changes noop to use queue scheduling code from elevator layer.
>> One can go back to old noop by deselecting CONFIG_IOSCHED_NOOP_HIER.
>>
>> Signed-off-by: Nauman Rafique <nauman@google.com>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Not sure why noop needs hierarchical fair queueing
> support, but this patch is so small we might as well
> take it to keep things consistent between schedulers.
>

Thinking more about it. It probably can be useful for the case ryo is
pointing out where fast SSD drivers are not making use of kernel IO
schedulers.

If they want group io schduling support on these SSDs, they can modify their
driver to make use of hierarchical noop.

> Acked-by: Rik van Riel <riel@redhat.com>

Thanks
Vivek

>
> -- 
> All rights reversed.
