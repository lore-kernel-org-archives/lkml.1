Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab0BPVGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:06:43 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51548 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab0BPVGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=v4Vuj/PAhWECDS4LAWFn0kFaYP8rslnkTjHHF6BIElrg/VmDLf6uNnH2C0HCXU/C1Y
         gTwh4eaDzsxR5BSxqfVV2cIeuiYvT/OppFXpBI9XpcfC/FnMLbhh0RhWuzf9emc5eNfR
         wo5omHxp7mb0j65nJ5WnRo3it2Kbue8Tloe7g=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 22:06:32 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
Cc: Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com> <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com>
In-Reply-To: <4B7AD35E.7000405@tmr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002162206.32797.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 16 Februar 2010, Bill Davidsen wrote:
> Volker Armin Hemmann wrote:
> > On Sonntag 14 Februar 2010, you wrote:
> >> In other words, 'auto-detection' for 1.x format devices is using an
> >> initrd/initramfs.
> > 
> > which makes 1.x format useless for everybody who does not want to deal
> > with initrd/initramfs.
> 
> You make this sound like some major big deal. are you running your own
> distribution? In most cases mkinitrd does the right thing when you "make
> install" the kernel, and if you are doing something in the build so
> complex that it needs options, you really should understand the options
> and be sure you're doing what you want.
> 
> Generally this involves preloading a module or two, and if you need it
> every time you probably should have built it in, anyway.
> 
> My opinion...

I am running my own kernels - and of course everything that is needed to boot 
and get the basic system up is built in. Why should I make the disk drivers 
modules? 
That does not make sense.

And the reason is simple: even when the system is completely fucked up, I want 
a kernel that is able to boot until init=/bin/bb takes over.

Glück Auf
Volker
