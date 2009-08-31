Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZHaU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZHaU5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZHaU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:57:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZHaU5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:57:45 -0400
Message-ID: <4A9C38F0.3070206@redhat.com>
Date: Mon, 31 Aug 2009 16:56:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
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
Subject: Re: [PATCH 22/23] io-controller: Support per cgroup per device weights
 and io class
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-23-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-23-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch enables per-cgroup per-device weight and ioprio_class handling.
> A new cgroup interface "policy" is introduced. You can make use of this
> file to configure weight and ioprio_class for each device in a given cgroup.
> The original "weight" and "ioprio_class" files are still available. If you
> don't do special configuration for a particular device, "weight" and
> "ioprio_class" are used as default values in this device.

Acked-by: Rik van Riel <riel@redhat.com>
