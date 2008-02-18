Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYBRQiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYBRQiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYBRQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:37:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44155 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYBRQhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:37:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: build #355 issue for v2.6.25-rc2-15-g1309d4e in function v4l2_i2c_attach
Date: Mon, 18 Feb 2008 17:36:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <200802171121.13119.toralf.foerster@gmx.de> <20080218131300.529b9862@gaivota>
In-Reply-To: <20080218131300.529b9862@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181736.03492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of February 2008, Mauro Carvalho Chehab wrote:
> On Sun, 17 Feb 2008 11:21:09 +0100
> Toralf Förster <toralf.foerster@gmx.de> wrote:
> 
> > Hello,
> > 
> > the build with the attached .config failed, make ends with:
> > ...
> >   CC      arch/x86/lib/usercopy_32.o
> >   AR      arch/x86/lib/lib.a
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> > WARNING: modpost: Found 1 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >   GEN     .version
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `v4l2_i2c_attach':
> > (.text+0x26c67): undefined reference to `i2c_attach_client'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> This bug were already fixed. I'm waiting for Linus to pull. The patches fixing
> it are available at:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git

Specific commits or just everything?

Rafael
