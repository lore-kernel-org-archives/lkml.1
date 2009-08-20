Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZHTCz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZHTCz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZHTCz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:55:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60396 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZHTCz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:55:57 -0400
Message-ID: <4A8CBAE1.9010408@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 10:54:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>	 <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>	 <4A8CB6F0.1020308@cn.fujitsu.com> <6599ad830908191941g77db4e69ve46bc8623f77d97f@mail.gmail.com>
In-Reply-To: <6599ad830908191941g77db4e69ve46bc8623f77d97f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Aug 19, 2009 at 7:37 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> I come to realize the "procs" file will make it much harder to convert
>> vmalloc/kmalloc with a different solution..
>>
> 
> Why do you think that?
> 

To avoid showing duplicate threadgroup pids, when dealing with a
thread, you have to check backwards to see if it's group pid
has been printed. Maybe it doesn't add much extra cost with your
proposal, we'll see.

