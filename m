Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYILFmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYILFmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 01:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYILFmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 01:42:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:61221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYILFmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 01:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pZmlymMb7hJLlqHkrSw9GoISNMvSjttQmRoWYZKjkIcls2ai2YNt3XCIVebW3OgTAZ
         uzbEt+TTa/OoeA9R+rOpD+2F17KWaCk++TrBkkXec0kQpwPUQiu3CHV/Np+4grni/06C
         +OQiP54gKB9gGePR3agQMjFzzb9cvT7LhFVao=
Message-ID: <19f34abd0809112242p27928541ydbfbb60ed84e34d2@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:42:36 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
Cc: davem@davemloft.net, netdev@vger.kernel.org, tgraf@suug.ch,
       penberg@cs.helsinki.fi, mingo@elte.hu, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080911165243.125a74cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080911205933.GA20032@localhost.localdomain>
	 <20080911165243.125a74cc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 1:52 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Sep 2008 22:59:33 +0200
> Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>>   #include <stdio.h>
>>
>>   main(void)
>>   {
>>           printf("%d\n", -1 >= sizeof(int));
>>   }
>>
>
> akpm:/home/akpm> gcc -W t.c
> t.c: In function 'main':
> t.c:5: warning: comparison between signed and unsigned
>
> Make of that what you will :)

It doesn't show up with -Wall and the kernel isn't compiled with -W
(aka. -Wextra) as far as I can see. Should it be turned on?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
