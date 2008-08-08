Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYHHH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYHHH5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYHHH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:57:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:35474 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYHHH5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s1Fasf4q7WddhzbWkgamO0vE6pgFXLEAlp//NkQfMTlHaUjeNx/hGkxA3ZZKUY6hh3
         upf4JQnouLprR5AE79Pb9cJrhNmvyFnr7t1m1J3UqzmZknFGv1QMyW/j5bShl+waSSjv
         LGS8BCXspZGpTMMTccG4YP2jzoFMEYakwsVug=
Message-ID: <8db1092f0808080057n588fff24r940b20358f5869f3@mail.gmail.com>
Date: Fri, 8 Aug 2008 09:57:43 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Linux 2.6.27-rc2] suspend to disk, libata problem
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Wilcox" <matthew@wil.cx>
In-Reply-To: <200808080052.03443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808071530o2f41b1b9p227dbb920e0a3961@mail.gmail.com>
	 <alpine.LFD.1.10.0808071541150.3462@nehalem.linux-foundation.org>
	 <200808080052.03443.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday, 8 of August 2008, Linus Torvalds wrote:

>>
>> Any chance to get this bisected? I realize that it's quite a few reboots,
>> and _maybe_ Jeff or Bartlomiej can just say "oh, duh, it's because of
>> Xyz", but the more likely thing is that without a bisect people will be
>> flailing around fairly blindly..
>
> Looks like another incarnation of http://bugzilla.kernel.org/show_bug.cgi?id=11178
>
> Maciej, can you try the patch at
> http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view
> please?
>
> Thanks,
> Rafael
>

Thanks
s2disk works, but I notice other problem during resume and normal
booting. Kernel very often stoped booting while detect PATA drive (DVD
drive):
http://unixy.pl/maciek/download/kernel/2.6.27-rc2/msi_path/img_0008.jpg

On 2.6.25.* stable it never happen.
On 2.6.26-rc* and 2.6.26.* stable -  sometimes
On 2.6.27-rc* - very often

So I try disable CONFIG_IDE and test s2disk again. Problem seems has
gone But a I have many warnings during resume (USB related?):
http://unixy.pl/maciek/download/kernel/2.6.27-rc2/without_config_ide/dmesg_resume_ahci.txt

Config kernel without CONFIG_IDE:
http://unixy.pl/maciek/download/kernel/2.6.27-rc2/without_config_ide/config-2.6.27-rc2


@Linus
If anybody tells me how do it, why not. I'm not kernel programmer (or
programmer in  generality). I'm only Linux user - newbie - who found
problem in kernel and think that better report it before stable 2.6.27
will be released than after.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
