Return-Path: <linux-kernel-owner+w=401wt.eu-S1750739AbXBKRNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750739AbXBKRNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXBKRNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:13:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19647 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbXBKRNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IHAakfgK8V0WIwQ/XDprDI8WgtUf2zpFakSwo8uvhYy6iuhhfdQ2XRbEkTRyCSXzrY6rLQhyjSuw/RuWEYFjGqy3s6q6pW62qYUeb6ha23daUYvYk93IK5rdDcvyeEnVAjHnBSnEQ541kZQvpo2QAoIbRDH6ZaNYttrYVbQnrLw=
Message-ID: <653402b90702110913k2e185b38of43e4e95f8c8c376@mail.gmail.com>
Date: Sun, 11 Feb 2007 18:13:28 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: 20-rc6-mm3 - BUG: at arch/i386/mm/highmem.c:52 kmap_atomic()
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070211034047.GE7501@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <653402b90702101145l2d5edbf9mc8873b62d377f1bf@mail.gmail.com>
	 <20070211034047.GE7501@slug>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Frederik Deweerdt <deweerdt@free.fr> wrote:
> On Sat, Feb 10, 2007 at 08:45:26PM +0100, Miguel Ojeda wrote:
> > When I was testing some stuff at 2.6.20-rc6-mm3 I found this at dmesg
> > multiple times.
> >
> Could you try this hotfix
> http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/hot-fixes/ntfs-kmap_atomic-atomicity-fix.patch
> and see if it works for you?
>
> Regards,
> Frederik
>

Andrew's patch seems to work for me, no more BUGs showed up.

Thanks,
Miguel

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
