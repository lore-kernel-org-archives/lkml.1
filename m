Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZKJMKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZKJMKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZKJMKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:10:34 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52191 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZKJMKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:10:33 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 07:10:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tRkYD4VHf9i84c4Ip4MENC2UF/t3Qn/E5XF68Baev4/xfRamXqdneivT7Iz/cLyMvx
         Y/0aNuS8zSTVUIkcCXA1CoifLX3Wx87VpjqBlsgGHaQmJiTo2hGkm+ilUgXGEctq65ip
         as4adHCXep6LZalnYx7hsf5BnZR6MTOBXWVK8=
MIME-Version: 1.0
In-Reply-To: <20091110110723.GH30802@alberich.amd.com>
References: <20091110110601.GG30802@alberich.amd.com>
	 <20091110110723.GH30802@alberich.amd.com>
Date: Tue, 10 Nov 2009 13:02:39 +0100
Message-ID: <b647ffbd0911100402k4f8648b8ref712f4c60fb8a7b@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86, ucode-amd: Load ucode-patches once and not 
	separately fo each CPU
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/10 Andreas Herrmann <herrmann.der.user@googlemail.com>:
> This also implies that corresponding log messages, e.g.
>
>  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
>
> show up only once on module load and not when ucode is updated for
> each CPU.

I like it.

One remark : should we perhaps provide a means of reloading the cached
firmware? Or is the standard procedure to reload microcode.ko in case
a new firmware file has been installed?

btw., if we could safely assume that all the cpus after the ucode
upgrade share the same version/patch-level of ucode, we would be able
to cache a single ucode instance once and use it for all. I don't
recall anyone clearly stating that such multi-cpu-type systems can't
really exist.

e.g. is it possible to have AMD systems with cpus which differ from
each other not only by their revisions (patch_level)?


-- Dmitry
