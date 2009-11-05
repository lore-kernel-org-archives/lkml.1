Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZKELAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZKELAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZKELAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:00:22 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58055 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZKELAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=A96k0644QFIW7fu/LVrJpXom+9PmlIr1qXcqr5blYY4/wxEfxz6TrVUybH1NIUyn46
         lzWTAFTjbPPZyAEJQz7lL+ykelc9c+/KHrSv40geklWBlxZdmec0H9aVX+D4d0O9Olrg
         MwZES9X5uZQGTvMHgIiFHShBS2UQK3KjNREiU=
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       huhb@lemote.com, yanh@lemote.com, Zhang Le <r0bertz@gentoo.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <20091105102838.GF12582@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com>
	 <20091105091841.GC12582@linux-mips.org>
	 <1257414523.1824.11.camel@falcon.domain.org>
	 <20091105102838.GF12582@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Thu, 05 Nov 2009 19:00:16 +0800
Message-ID: <1257418816.3067.8.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > You're ifdefing on Loongson 2F - doesn't that mean that you can't have a
> > > kernel that supports both Loongson 2E and 2F?
> > > 
> > 
> > Currently, not consider it yet;) It's a little hard to cope with, should
> > we consider it at this moment? if yes, I will try it with the help of
> > exisiting machtype asap. but I think it's better to let it be the future
> > job ;)
> 
> Fair enough - though I'm sure Linux distributions would be happy to have
> one kernel variant less to ship.
> 

Yup, linux distributions will like it.

but just remembered that: the instruciton set of loongson2e and
loongson2f is different, -march=loongson2e, -march=loongson2f. so it
will be not possible to merge them together, but I will try to merge the
2f support, so please wait for me merging fuloong2f & yeeloon2f, I will
do it tonight, it is really an interesting job to do ;)

Regards,
	Wu Zhangjin

