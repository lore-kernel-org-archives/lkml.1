Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZGAOWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZGAOWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZGAOWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:22:41 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40665 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZGAOWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WpGZr8tY2HKe1Z1f/KuFchaPnictVR/3sGoo8XloWqnt0RQUzhq0EdCjKlBKddWXfJ
         3cXdhKd82UmtzgHfdOiKa4AxOALAAAtf50Cru85tN79M7kXXmUWoG6GB4gscqWp3MKgt
         JMhBeci88eOMlRKMaSd10APq8jL1wAE2yu5lk=
MIME-Version: 1.0
In-Reply-To: <b9df5fa10907010615m25664ebao223ef1f770ebbeeb@mail.gmail.com>
References: <b9df5fa10907010615m25664ebao223ef1f770ebbeeb@mail.gmail.com>
Date: Wed, 1 Jul 2009 19:52:41 +0530
Message-ID: <93655eb70907010722t25dcbaf0j7323800b55354f32@mail.gmail.com>
Subject: Re: Kernel build failure.
From: Satish Eerpini <eerpini@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   I'm facing the following problem in building kernel.
> Config attached.
>
>
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
> kernel/built-in.o(.text+0x630e): In function `alloc_fair_sched_group':
> : undefined reference to `.L3922'
> kernel/built-in.o(.text+0x6359): In function `alloc_fair_sched_group':
> : undefined reference to `.L3923'
> kernel/built-in.o(.text+0x432c6): In function `add_del_listener':
> : undefined reference to `.L364'
> drivers/built-in.o(.text+0x85e5e): In function `igdng_compute_m_n':
> : undefined reference to `__udivdi3'
> drivers/built-in.o(.init.text+0x3c1d): In function `con_init':
> : undefined reference to `.L1460'
> net/built-in.o(.text+0x414bb): In function `__tcp_alloc_md5sig_pool':
> : undefined reference to `.L1763'
> make: *** [.tmp_vmlinux1] Error 1
>

built the 2.6.31-rc1-git6 kernel with the config you attached and
everything worked fine, and the kernel compilation was done
successfully.

Thanks
Satish



-- 
http://satish.playdrupal.com
