Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbZIIEpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbZIIEpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZIIEpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZIIEpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:45:53 -0400
Message-ID: <4AA732C7.70003@redhat.com>
Date: Wed, 09 Sep 2009 00:44:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 25/23] io-controller: fix queue vs group fairness
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <20090908222827.GC3558@redhat.com>
In-Reply-To: <20090908222827.GC3558@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o I found an issue during test and that is if there is a mix of queue and group
>   at same level, there can be fairness issue. For example, consider following
>   case.

Acked-by: Rik van Riel <riel@redhat.com>

(assuming the cleanups are done in V10 - the artifact of
  a wraparound hitting exactly 0 should not be an issue)

-- 
All rights reversed.
