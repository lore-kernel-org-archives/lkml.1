Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZBDHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZBDHjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 02:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZBDHjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 02:39:01 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZBDHjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 02:39:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=QUqRIvZAMxsTsJe4tfZ+QJNeESm2+AE9TbXhuQ7G9M1EoPipmWO7sZo5/UyuoShTY
	bMwkRzwdVEXLPXJFD7p0g==
MIME-Version: 1.0
In-Reply-To: <4988EADB.4050508@cn.fujitsu.com>
References: <498879F1.9040009@xenotime.net>
	 <1233694085-23893-1-git-send-email-cascardo@holoscopio.com>
	 <4988EADB.4050508@cn.fujitsu.com>
Date: Tue, 3 Feb 2009 23:38:54 -0800
Message-ID: <6599ad830902032338q7018112cm499b0b6e83308707@mail.gmail.com>
Subject: Re: [PATCH] trivial: fix where cgroup documentation is not correctly 
	referred to
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, trivial@kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, rdunlap@xenotime.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.35
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 5:09 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Thadeu Lima de Souza Cascardo wrote:
>> cgroup documentation was moved to Documentation/cgroups/. There are some
>> places that still refer to Documentation/controllers/,
>> Documentation/cgroups.txt and Documentation/cpusets.txt. Fix those.
>>
>
> After grep, I think there's no wrong ref anymore.
>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks for this cleanup.

Paul

>
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>> ---
>>  Documentation/00-INDEX                         |    4 ++--
>>  Documentation/cgroups/00-INDEX                 |   18 ++++++++++++++++++
>>  Documentation/kernel-parameters.txt            |    4 ++--
>>  Documentation/scheduler/sched-rt-group.txt     |    2 +-
>>  Documentation/vm/numa_memory_policy.txt        |    3 ++-
>>  Documentation/vm/page_migration                |    3 ++-
>>  Documentation/x86/x86_64/fake-numa-for-cpusets |    5 +++--
>>  include/linux/cgroup.h                         |    5 ++++-
>>  init/Kconfig                                   |    2 +-
>>  9 files changed, 35 insertions(+), 11 deletions(-)
>>  create mode 100644 Documentation/cgroups/00-INDEX
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
