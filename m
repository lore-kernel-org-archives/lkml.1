Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbZHaVDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbZHaVDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 17:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZHaVDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 17:03:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZHaVDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 17:03:35 -0400
Date: Mon, 31 Aug 2009 17:01:54 -0400
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
Subject: Re: [PATCH 23/23] io-controller: debug elevator fair queuing
	support
Message-ID: <20090831210154.GA8229@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-24-git-send-email-vgoyal@redhat.com> <4A9C3951.8020302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9C3951.8020302@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 04:57:53PM -0400, Rik van Riel wrote:
> Vivek Goyal wrote:
>> o More debugging help to debug elevator fair queuing support. Enabled under
>>   CONFIG_DEBUG_ELV_FAIR_QUEUING. Currently it prints vdisktime related
>>   trace messages in blktrace.
>>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Is this meant for merging upstream, or just as a temporary
> debugging help while this sits in a subsystem tree or -mm?

I think it would be good if this also is merged upstream. A useful
debugging help to track fairness and latecy related issues.

Thanks
Vivek
