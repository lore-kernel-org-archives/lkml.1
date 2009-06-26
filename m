Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZFZA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZFZA1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZFZA1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:27:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63113 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZFZA1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:27:40 -0400
Message-ID: <4A4415EA.4090201@cn.fujitsu.com>
Date: Fri, 26 Jun 2009 08:27:22 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH] io-controller: do some changes of io.policy interface
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-19-git-send-email-vgoyal@redhat.com> <6599ad830906241452t76e64815s7d68a22a6e746a59@mail.gmail.com> <4A435038.60406@cn.fujitsu.com> <20090625125513.GA25439@redhat.com>
In-Reply-To: <20090625125513.GA25439@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> 
> Hi Gui,
> 
> Thanks for the patch. "unsigned long" for ioprio_class is too big. How
> about using "unsigned short"? I noticed that in io_cgroup also we are
> using "unsigned long". I will fix that.
> 
> For storing weight now we are planning to use "unsigned int". Can you
> please switch to that.

  Sure, i'll post another patch to switch to that.

> 
> Thanks
> Vivek
> 
> 
> 

-- 
Regards
Gui Jianfeng

