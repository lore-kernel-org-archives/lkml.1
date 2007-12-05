Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXLEHZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXLEHZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXLEHZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:25:23 -0500
Received: from [222.73.24.84] ([222.73.24.84]:60105 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXLEHZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:25:22 -0500
Message-ID: <475651A9.3000703@cn.fujitsu.com>
Date: Wed, 05 Dec 2007 15:22:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: WANG Cong <xiyou.wangcong@gmail.com>, sam@ravnborg.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
References: <47555AF1.8090304@gmail.com> <20071204150734.GE6113@hacking> <47557076.8080508@gmail.com> <20071205070127.GG2460@hacking> <47564F35.30706@gmail.com>
In-Reply-To: <47564F35.30706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> WANG Cong wrote:
>>>> I think, you forgot to free(3) the memory you calloc(3)'ed and
>>>> malloc(3)'ed above.
>>> It's a simple program where whole body is in main().  Why bother?
>>> What's the benefit of adding hash-table iterating free logic?
>>>
>> Personally, I think memory leaks are bugs. And we hate bugs. ;)
> 
> Trust me.  As a person buried alive in bug reports, I hate bugs too.  I
> just don't agree that this type of programs should free all its
> resources before exiting.  How about adding a comment saying /* we're
> going out anyway, don't bother freeing hashtable */?
> 

I don't consider this as memory leak. I agree that a comment should be
enough. :)

	Li Zefam
