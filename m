Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZIBUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZIBUC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZIBUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:02:26 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:55750 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZIBUCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sbA1RpLag1avaxypU6elvbjgQXiZKmAN4AGZUMrzw04wqYIp1PW76afpQEVsHGw335
         /GOpssUV+LHtGvvNrTzMjLJi/Odr5Qp0384bg5uXQKfyPcc+YnDVoxFI54gFoJOOB+hM
         DFSlqMnjbcX4pPDd56GEP5GBKWABRtisCkdJI=
MIME-Version: 1.0
In-Reply-To: <ff13736137802f78cf492d13c43c1af1.squirrel@webmail-b.css.fujitsu.com>
References: <20090902.205137.71100180.ryov@valinux.co.jp>
	 <ff13736137802f78cf492d13c43c1af1.squirrel@webmail-b.css.fujitsu.com>
Date: Thu, 3 Sep 2009 01:32:24 +0530
X-Google-Sender-Auth: e3446829d4036042
Message-ID: <661de9470909021302ge86d01s5d107dc2b5cffbc5@mail.gmail.com>
Subject: Re: a room for blkio-cgroup in struct page_cgroup
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/2 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Ryo Tsuruta wrote:
>> Hi Kamezawa-san,
>>
>> As you wrote before (http://lkml.org/lkml/2009/7/22/65)
>>> To be honest, what I expected in these days for people of blockio
>>> cgroup is like following for getting room for themselves.
>> <<snip>>
>>> --- mmotm-2.6.31-Jul16.orig/include/linux/page_cgroup.h
>>> +++ mmotm-2.6.31-Jul16/include/linux/page_cgroup.h
>>> @@ -13,7 +13,7 @@
>>>  struct page_cgroup {
>>>       unsigned long flags;
>>>       struct mem_cgroup *mem_cgroup;
>>> -     struct page *page;
>>> +     /* block io tracking will use extra unsigned long bytes */
>>>       struct list_head lru;       /* per cgroup LRU list */
>>> };
>>
>> Have you already added a room for blkio_cgroup in struct page_cgroup?
> No.
>

The diff above is unclear, are you removing struct page from page_cgroup?

Balbir Singh
