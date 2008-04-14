Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbYDNIJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbYDNIJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYDNIJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:09:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYDNIJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:09:34 -0400
Message-ID: <480310C5.1070102@cn.fujitsu.com>
Date: Mon, 14 Apr 2008 16:07:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix oops in oom handling
References: <4802FF10.6030905@cn.fujitsu.com>	 <20080414161428.27f3ee59.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830804140053y4bcdceeatc9763c1e8c1aaf44@mail.gmail.com>
In-Reply-To: <6599ad830804140053y4bcdceeatc9763c1e8c1aaf44@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Apr 14, 2008 at 12:14 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>  Paul, I have one confirmation. Lock hierarchy of
>>         cgroup_lock()
>>         ->      read_lock(&tasklist_lock)
>>
>>  is ok ? (I think this is ok.)
> 
> Should be fine, I think.
> 
> Have you built/booted with lockdep?
> 

I should have done this. :(

I'll check it.

> Paul
> 
