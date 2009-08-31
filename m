Return-Path: <linux-kernel-owner+w=401wt.eu-S1751091AbZHaNsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbZHaNsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZHaNsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:48:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZHaNs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:48:29 -0400
Date: Mon, 31 Aug 2009 09:46:33 -0400
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
Subject: Re: [PATCH 16/23] io-controller: deadline changes for hierarchical
	fair queuing
Message-ID: <20090831134633.GA3758@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-17-git-send-email-vgoyal@redhat.com> <4A9B3FD3.6000407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B3FD3.6000407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 11:13:23PM -0400, Rik van Riel wrote:
> Vivek Goyal wrote:
>> This patch changes deadline to use queue scheduling code from elevator layer.
>> One can go back to old deadline by selecting CONFIG_IOSCHED_DEADLINE_HIER.
>                                     ^ deselecting ?
>

Yes. Its a typo. Should be "deselecting". Will fix the comment.

Thanks
Vivek

>> Signed-off-by: Nauman Rafique <nauman@google.com>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Acked-by: Rik van Riel <riel@redhat.com>
>
> -- 
> All rights reversed.
