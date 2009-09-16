Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZIPIZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZIPIZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbZIPIZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:25:53 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:42145 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbZIPIZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l43MIZmGvaj8z1kZHnWLDbIK8VPVpgIGNQOhOa9wSf0IZNXxsnpVKR10Y/Hx6O59DH
         Y8GwhR/X5uBlxyY9EdwKm3oQEEpxfSv+IYnkFBwML/QQdewzNmetRP8Tudsejc3622ST
         GIzCX29WLySOBWLvS9H8EKxWT4SlQO03ESmwc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.00.0909152315380.25569@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0909152224400.29857@sister.anvils>
	 <20090916092644.fb53279a.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.1.00.0909152315380.25569@chino.kir.corp.google.com>
Date: Wed, 16 Sep 2009 16:25:54 +0800
Message-ID: <2375c9f90909160125t20b8cce0w18dddbccdf2010a@mail.gmail.com>
Subject: Re: [BUGFIX][mmotm] fix walk system ram range patch (Was Re: mmotm on 
	powerpc: walk_memory_resource?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 2:16 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 16 Sep 2009, KAMEZAWA Hiroyuki wrote:
>
>> Index: mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
>> ===================================================================
>> --- mmotm-2.6.31-Sep14.orig/arch/powerpc/mm/mem.c
>> +++ mmotm-2.6.31-Sep14/arch/powerpc/mm/mem.c
>> @@ -166,7 +166,7 @@ walk_system_ram_range(unsigned long star
>>       }
>>       return ret;
>>  }
>> -EXPORT_SYMBOL_GPL(walk_memory_resource);
>> +EXPORT_SYMBOL_GPL(walk_system_ram_range);
>>
>>  /*
>>   * Initialize the bootmem system and give it all the memory we
>>
>
> Um, doesn't drivers/infiniband/hw/ehca/ehca_mrmw.c need to be fixed too?

Yes, all callers of walk_memory_resource() should be fixed.
