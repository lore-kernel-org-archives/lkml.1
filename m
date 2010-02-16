Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0BPOhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:37:45 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:64795 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab0BPOho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=kif72Hirgr+q1mByELFRrKf3KuVZNtgb+En69ogfI0BrIbrYGcq5MX1LpoU8zbHyHP
         OiblYkyV80gGBe5JC14lanRDFp2o/x06ec1GgCcbYVrZpD8wL0Y8Ry+ceMph7k6EDXL7
         yKBssrkOPJANVo6k5JIhznDb/K36xcmIw5j+0=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: John Robinson <john.robinson@anonymous.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 15:37:08 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31.12r4; KDE/4.4.0; x86_64; ; )
Cc: Linux RAID <linux-raid@vger.kernel.org>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002142013.24922.volkerarmin@googlemail.com> <4B7AAB8D.9030009@anonymous.org.uk>
In-Reply-To: <4B7AAB8D.9030009@anonymous.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002161537.08487.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 16 Februar 2010, John Robinson wrote:
> On 14/02/2010 19:13, Volker Armin Hemmann wrote:
> > On Sonntag 14 Februar 2010, you wrote:
> >> On 14/02/2010 18:40, Volker Armin Hemmann wrote:
> >>> On Sonntag 14 Februar 2010, you wrote:
> >>>> In other words, 'auto-detection' for 1.x format devices is using an
> >>>> initrd/initramfs.
> >>> 
> >>> which makes 1.x format useless for everybody who does not want to deal
> >>> with initrd/initramfs.
> >> 
> >> True, but afaik every distro uses an initrd/initramfs and bundles tools
> >> making it easy to manage and customise them, so what's the problem?
> > 
> > and distros do it because of all the drivers they have to ship. But for
> > example I am not bound by such limitations. Why should I deal with that?
> > It is hard enough not to forget 'make modules_install'. And now add
> > initrd. Autodetecting just works - but if you use an initrd an it
> > doesn't. Where do you start?
> > 
> > Initrd's maybe great for distro packagers, but are they really usefull
> > for anybody else?
> 
> Not just for distro packagers, they're useful for distro users, which
> are presumably 99% of Linux users these days, including the vast
> majority of enterprise users who like tested, supported systems.
> 
> But even for people building their own kernels, initrd/initramfs are
> useful if you're using LVM, or indeed trying to boot off anything that's
> not a simple device.

so assume you have an initrd and metadata 1.x without auto assembling.

You do some changes to the raid and screw up something else. Next boot nothing 
works. Mostly because the mdadm.conf in your initrd is not correct.

You whip out your trusty usb stick with a resuce system - and you are stuck. 
If autoassembling would work, you would have working md devices you could 
mount and edit the files you have to. But you don't and the mdadm.conf in the 
initrd is outdated.

Sounds like 'you are screwed'.

Or you have that famous grub boot line to have root autoassembled but the 
device names changed. 

Yeah, sounds really great.

And that because ...? Is there any good reason not to have autoassmbling in 
the kernel?

Glück Auf
Volker
