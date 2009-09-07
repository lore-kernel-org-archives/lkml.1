Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZIGCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZIGCPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbZIGCPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:15:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758362AbZIGCPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:15:40 -0400
Message-ID: <4AA46C6E.4010109@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 10:14:06 +0800
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
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4A9DC33E.6000408@cn.fujitsu.com>
In-Reply-To: <4A9DC33E.6000408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Here is the vanilla kernel and V9 comparision.

                           Normal Read  |  Random Read  |  Normal Write  |  Random Write

vanilla(Avg of 3 times)   67580 KiB/s     3540 KiB/s      61964 KiB/s      9823 KiB/s

V9(Avg of 3 times)        68954 KiB/s     3567 KiB/s      60654 KiB/s      9858 KiB/s

Performance                +2.0%           +0.7%          -2.1%             +0.3%


