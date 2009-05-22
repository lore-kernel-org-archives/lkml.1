Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZEVIg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZEVIg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZEVIgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:36:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64916 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbZEVIgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:36:14 -0400
Message-ID: <4A16644F.1090201@cn.fujitsu.com>
Date: Fri, 22 May 2009 16:37:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: remove forward declaration from sched.h
References: <4A1645D4.5010001@cn.fujitsu.com> <20090522171737.e9916d1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090522171737.e9916d1b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 22 May 2009 14:27:32 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> This forward declaration seems pointless.
>>
>> compile tested.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Nice catch. (but I don't know why this sneaked into..)

It was long long ago when memcg was merged ;)

| commit 78fb74669e80883323391090e4d26d17fe29488f
| Author: Pavel Emelianov <xemul@openvz.org>
| Date:   Thu Feb 7 00:13:51 2008 -0800
|
|    Memory controller: accounting setup

But in that patch, the forward declation in sched.h was unneeded.

