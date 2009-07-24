Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbZGXD0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbZGXD0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGXD0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:26:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZGXD0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:26:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HQ8osgeGEcr4jFAYj36YbzjREnSakEcp73lc98bCGjIWaiSOK5Y2V6W5L/K3A5F38
	xpqBsTEDTvf5iZJemKpwA==
MIME-Version: 1.0
In-Reply-To: <20090724120811.a581eea5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090723152647.D9391722@kernel> <4A692444.2030303@cn.fujitsu.com>
	 <20090724120811.a581eea5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 23 Jul 2009 20:26:47 -0700
Message-ID: <2f86c2480907232026v143aef06t652796b489b7ad2c@mail.gmail.com>
Subject: Re: [RFC][PATCH] flexible array implementation v4
From: Benjamin Blum <bblum@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com, xiyou.wangcong@gmail.com,
       hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 8:08 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 24 Jul 2009 11:02:28 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>> Dave Hansen wrote:
>> > Remaining issues:
>> > - How should we deal with out-of-range indexes, especially
>> >   in flex_array_get() which returns void*?  ERR_PTR()?
>> >   BUG_ON()?  return NULL (current behavior)?
>> > - Should care be taken not to allow a flex_array_get() to
>> >   an index where no flex_array_put() was done?
>> > - Should we decay further than just packing things into the
>> >   'base' page?  Should we actually kmalloc() less than a
>> >   page at times when it will fit?
>> >
>>
>> I sugguest find some candidate users and see how this flex_array
>> fits them.
>>
> Hmm, can't we rewrite cgroup->tasks file using this ?
> I'll try some if I have time.
>
> -Kame
>
>
>

I can do that; it would go nicely on top of my procs file patch
series, but probably wants to wait until after both patch series have
been accepted (see http://lkml.org/lkml/2009/7/23/330 )
