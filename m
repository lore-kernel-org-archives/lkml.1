Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZLZXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZLZXhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 18:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZLZXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 18:37:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38206 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZLZXh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 18:37:29 -0500
MIME-Version: 1.0
In-Reply-To: <20091226133011.GA10944@balbir.in.ibm.com>
References: <cover.1261786326.git.kirill@shutemov.name>
	 <20091226133011.GA10944@balbir.in.ibm.com>
Date: Sun, 27 Dec 2009 01:37:28 +0200
Message-ID: <cc557aab0912261537n2f2e798u4338b4d1f31067e6@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] cgroup notifications API and memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: balbir@linux.vnet.ibm.com
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 3:30 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Kirill A. Shutemov <kirill@shutemov.name> [2009-12-26 02:30:56]:
>
>> This patchset introduces eventfd-based API for notifications in cgroups and
>> implements memory notifications on top of it.
>>
>> It uses statistics in memory controler to track memory usage.
>>
>> Output of time(1) on building kernel on tmpfs:
>>
>> Root cgroup before changes:
>>       make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
>> Non-root cgroup before changes:
>>       make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
>> Root cgroup after changes (0 thresholds):
>>       make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
>> Non-root cgroup after changes (0 thresholds):
>>       make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
>> Root cgroup after changes (1 thresholds, never crossed):
>>       make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
>> Non-root cgroup after changes (1 thresholds, never crossed):
>>       make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total
>>
>> Any comments?
>
> Could you please add some documentation for end users.

Sure. I'll send new version of patchset with documentation soon.

> I've just
> compiled a kernel with your changes for test. Also, is there a reason
> not to use cgroupstats?

I'm not sure that understand you correctly. Could you explain the idea?
