Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXCXLyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXCXLyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 07:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXCXLyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 07:54:23 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:25382 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbXCXLyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 07:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ouroVoA1Ret/4QAs7pZgAhPr2cpDQscWvdoOexTgFMLq6OjZFeHYO/lUkmXV/MgYN2LTkU9/NevEuz+tV4Cufh2f6HMnSvGxIWkSMheNZUYn2EB88hkxMHpo6zXMg+TQVorQgUx7ZxsqUEQ9/r3LGZspbDY71IS1KNVqLMWdjPE=
Message-ID: <6bffcb0e0703240454g231d91bex7ae344e05a402d23@mail.gmail.com>
Date: Sat, 24 Mar 2007 12:54:20 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-03-24-00-14.tar.gz uploaded
Cc: "Adrian Bunk" <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> The mm snapshot broken-out-2007-03-24-00-14.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-24-00-14.tar.gz
>
> It contains the following patches against 2.6.21-rc4:
>

Please drop net-uninline-skb_put-fix.patch

In file included from include/linux/if_ether.h:111,
                 from include/linux/netdevice.h:29,
                 from include/net/sock.h:48,
                 from kernel/audit.c:54:
include/linux/skbuff.h: In function 'skb_put':
include/linux/skbuff.h:885: warning: implicit declaration of function
'skb_over_panic'
  CC      kernel/auditfilter.o
In file included from include/linux/netlink.h:139,
                 from kernel/auditfilter.c:28:
include/linux/skbuff.h: In function 'skb_put':
include/linux/skbuff.h:885: warning: implicit declaration of function
'skb_over_panic'
  CC      kernel/auditsc.o
In file included from include/linux/netlink.h:139,
                 from kernel/auditsc.c:59:
include/linux/skbuff.h: In function 'skb_put':
include/linux/skbuff.h:885: warning: implicit declaration of function
'skb_over_panic'
  CC      kernel/ksysfs.o
  CC      kernel/softlockup.o
  CC      kernel/relay.o
  CC      kernel/utsname_sysctl.o
  CC      kernel/delayacct.o
In file included from include/linux/netlink.h:139,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from include/linux/delayacct.h:21,
                 from kernel/delayacct.c:20:
include/linux/skbuff.h: In function 'skb_put':
include/linux/skbuff.h:885: warning: implicit declaration of function
'skb_over_panic'
  CC      kernel/taskstats.o
In file included from include/linux/netlink.h:139,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from kernel/taskstats.c:20:
include/linux/skbuff.h: In function 'skb_put':
include/linux/skbuff.h:885: warning: implicit declaration of function
'skb_over_panic'

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
