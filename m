Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab0BPWSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:18:44 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54092 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab0BPWSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:18:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=jI6FSbrJCMzBKj2ArCT67mzyLXmn/zBLadHKe2svi1cN7iYAS/oppLadgqPSH6hJ0b
         42AMY1oKpAvjnsabQBitu/xWnArc8taZ1ZjSMSZ/n7q+sFAmpyCNlbA4ATmE032qCPFK
         xCgqSFA/iBxwox5yaBZL1fFNo4rW36OYL9Y7Q=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 23:18:33 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
References: <201002140251.59668.volkerarmin@googlemail.com> <201002162206.32797.volkerarmin@googlemail.com> <20100216220020.GA1036@emergent.ellipticsemi.com>
In-Reply-To: <20100216220020.GA1036@emergent.ellipticsemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002162318.33950.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 16 Februar 2010, Nick Bowler wrote:
> On 22:06 Tue 16 Feb     , Volker Armin Hemmann wrote:
> > On Dienstag 16 Februar 2010, Bill Davidsen wrote:
> > > Volker Armin Hemmann wrote:
> > > > On Sonntag 14 Februar 2010, you wrote:
> > > >> In other words, 'auto-detection' for 1.x format devices is using an
> > > >> initrd/initramfs.
> > > > 
> > > > which makes 1.x format useless for everybody who does not want to
> > > > deal with initrd/initramfs.
> > > 
> > > You make this sound like some major big deal. are you running your own
> > > distribution? In most cases mkinitrd does the right thing when you
> > > "make install" the kernel, and if you are doing something in the build
> > > so complex that it needs options, you really should understand the
> > > options and be sure you're doing what you want.
> > > 
> > > Generally this involves preloading a module or two, and if you need it
> > > every time you probably should have built it in, anyway.
> > > 
> > > My opinion...
> > 
> > I am running my own kernels - and of course everything that is needed to
> > boot and get the basic system up is built in. Why should I make the disk
> > drivers modules?
> > That does not make sense.
> 
> I agree that it makes little sense to make something a module when you
> can't unload it anyway, but...
> 
> > And the reason is simple: even when the system is completely fucked up, I
> > want a kernel that is able to boot until init=/bin/bb takes over.
> 
> I put a complete set of recovery tools into my initramfses so that when
> the system is completely fucked up, I have a kernel that is able to boot
> until rdinit=/bin/zsh (or /bin/bb, if you prefer) takes over.
> 
> This has the added advantage of working when the root filesystem cannot
> be mounted at all: a scenario which does not seem too far-fetched when
> the filesystem is located on a raid array.

and what do you do if you have to boot from a cd/usb stick and need to access 
the raid?

Simple with auto assembling. Not so much without.

Glück Auf,
Volker
