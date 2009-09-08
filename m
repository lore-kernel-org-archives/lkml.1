Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZIHN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZIHN5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZIHN5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510AbZIHN5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:57:18 -0400
Date: Tue, 8 Sep 2009 09:55:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
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
Message-ID: <20090908135536.GD15974@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4A9DC33E.6000408@cn.fujitsu.com> <4AA46C6E.4010109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA46C6E.4010109@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 10:14:06AM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> Here is the vanilla kernel and V9 comparision.
> 
>                            Normal Read  |  Random Read  |  Normal Write  |  Random Write
> 
> vanilla(Avg of 3 times)   67580 KiB/s     3540 KiB/s      61964 KiB/s      9823 KiB/s
> 
> V9(Avg of 3 times)        68954 KiB/s     3567 KiB/s      60654 KiB/s      9858 KiB/s
> 
> Performance                +2.0%           +0.7%          -2.1%             +0.3%
> 

Thanks Gui. So that's lot of improvements from previous versions. I remember
you were noticing 7% regressions in buffered write performance.

Thanks
Vivek
