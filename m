Return-Path: <linux-kernel-owner+w=401wt.eu-S1751309AbZHZO7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbZHZO7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZHZO7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:59:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35603 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZHZO7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TBoi/Ovtmtpx6FPEL8OBfaStqY3NLxZ9dX5gm+x9/OCmzn2rFg732ZE5f+zZWv4PHx
         /Y33oDKSYgpj6edR7PyKIXq26JWKXkBHUbV58TJ/GY/4p7DqCNvnrPUltXVEtbBRiPXs
         6u7wJMnp5xYASogRLAPjWcTrzNmzAchUAVuaQ=
MIME-Version: 1.0
In-Reply-To: <200908261601.05734.ml_kernel@mortal-soul.de>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.2bH.CtGlKB@chimera>
	 <84144f020908252317j202aa459u27c40eed34debd6@mail.gmail.com>
	 <200908261601.05734.ml_kernel@mortal-soul.de>
Date: Wed, 26 Aug 2009 17:59:30 +0300
X-Google-Sender-Auth: 2a064fe2103a5aec
Message-ID: <84144f020908260759q6554971dva6cc89a0ad9821b@mail.gmail.com>
Subject: Re: [Bug #14011] Kernel paging request failed in kmem_cache_alloc
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Matthias Dahl <ml_kernel@mortal-soul.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 5:01 PM, Matthias Dahl<ml_kernel@mortal-soul.de> wrote:
>> Can you reproduce the bug without the proprietary nvidia module that
>> seems to be loaded?
>
> I am sorry but I forgot to test that and right now I am not very keen on
> trying again since this is my primary machine and I had quite some fs
> corruption (ext4 on md raid5 -> no barriers) the last times. :-( But this also
> happened w/o Xorg ever being run during that session (though naturally the
> nvidia kernel module was still loaded).

Sure, I can understand that. The bug looks like regular slab
corruption which could have been caused the nvidia blob. So I think
the issue should be closed unless someone can reproduce it without the
blob.

That said, sys_inotify_add_watch() also appears in the trace and
there's been quite a few bug fixes in that area recently so I guess we
should CC Eric Paris just in case the oops rings a bell to him.

                        Pekka
