Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYHDQ2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYHDQ2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYHDQ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:27:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYHDQ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:27:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PBkWZ/RZiBk1kewzs2bT4SOVc6jkMr5b8tgkZxRI3eFxyoeyRM69LBKoPtd5SjC2N
	PugpbDsOH2jXCQf4IxZqg==
Message-ID: <6599ad830808040927h333a7841y411187833f38c1ac@mail.gmail.com>
Date: Mon, 4 Aug 2008 09:27:30 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cpuset: Add comments for update_domain_attr_tree
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48916CC9.8020705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <489121F8.2020008@cn.fujitsu.com> <48916CC9.8020705@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:42 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> This patch was reviewed by Li Zefan and was revised on his suggestion before sent.
> Thanks Li Zefan.
>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
>
> Lai Jiangshan wrote:
>> Add comments for update_domain_attr_tree().
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index adf66c0..fed1f42 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -487,15 +487,21 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
>>  {
>>       if (dattr->relax_domain_level < c->relax_domain_level)
>>               dattr->relax_domain_level = c->relax_domain_level;
>> -     return;
>>  }
>>
>> +/*

If you're going to add a comment block, maybe it's worth making it
docbook-compatible? So /** at the start, and then following the proper
docbook style conventions in kernel-doc-nano-HOWTO.txt ?

Paul
