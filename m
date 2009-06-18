Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZFRDFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZFRDFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZFRDF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:05:27 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:44623 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZFRDF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tU9kYyew8m9zhhg7aC0On9AAv5gO73uJtletmt/BzSGPfX82Jl8Lc0jwV3CMFj6KDH
         98xTJ6W1NPS6wPuOPYX7dwg4K9qddVLG4gBUivUuWbzUTyKUGPe+Fw1ySTogWxiv/oJq
         6bjiA8vvSlQQHpFpppS/TX7G8cUfbKEfNxQJQ=
MIME-Version: 1.0
In-Reply-To: <20090601100211.GD14373@duck.suse.cz>
References: <17cc26190905290122u52e2f9a1q15103557e214883e@mail.gmail.com>
	 <20090601100211.GD14373@duck.suse.cz>
Date: Thu, 18 Jun 2009 11:05:27 +0800
Message-ID: <e8775dd00906172005m140df95bnb3a0006318b3edac@mail.gmail.com>
Subject: Re: JFFS2 filesystem problem
From: Jason Liu <liu.h.jason@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: anees a m <aneesgnu@gmail.com>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/1 Jan Kara <jack@suse.cz>:
>  Hello,
>
> On Fri 29-05-09 13:52:05, anees a m wrote:
>> Iam uses JFFS2 filesystem for an embedded flash device. But when the power
>> is removed i between, the JFFS2 filesystem is corrupted.Resulting in fails.
>> Iam able to find that the JFFS2 garbage collector is causing the problem. If
>> mounted as READ only, I dont have an issue, but mounting write only is
>> resulting in corrupted filesystem some times.
>>
>> Unfortunately I need to mount it with read write support.
>  I'm not sure why you decided to write to linux-ext4 mailing list, to me
> and to Nick. Anyway, the right person for this report seems to be David
> Woodhouse who's listed as a maintainer of JFFS2 filesystem.
>  Adding him to CC.
>
>                                                                        Honza
Yes, I have the same problems. Have you resolved the issues?What's the
kernel version you are using. We are using, .2.6.28 kernel.
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
