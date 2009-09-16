Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZIPEuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZIPEuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZIPEuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:50:11 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:62133 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZIPEuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:50:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=c4GZEZkLW2LvdS1qdTRGxhLmPFnWomTWZzRV9yRH0Y2lZsPdHxxH+Q/D/+oApxd2D9
         9yx2n7lTjAhMtn0cqVwMvsh3XKmxFPnqaDmoOTHuND9bvg7WdyZv7FBVJTcRcJqQoWUa
         CQ7CO8pQU3T49NWplAAFJgbHH9rNHDFy2TtIU=
Date: Tue, 15 Sep 2009 21:49:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: "Song, Barry" <Barry.Song@analog.com>, Barry Song <21cnbao@gmail.com>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [Uclinux-dist-devel] [PATCH] input/keyboard: add ADP5588
	QWERTYI2C Keyboard Input device driver
Message-ID: <20090916044957.GE2756@core.coreip.homeip.net>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> <20090915062050.GB10232@core.coreip.homeip.net> <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com> <20090915162655.GB29241@core.coreip.homeip.net> <3c17e3570909152049nd801aeds3915e5889d6181f0@mail.gmail.com> <8bd0f97a0909152103m4848fe9ayb5835a6844ea4ca1@mail.gmail.com> <0F1B54C89D5F954D8535DB252AF412FA04BEE48B@chinexm1.ad.analog.com> <8bd0f97a0909152125l29683107h93837b7388a9d20f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0909152125l29683107h93837b7388a9d20f@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:25:56AM -0400, Mike Frysinger wrote:
> On Wed, Sep 16, 2009 at 00:18, Song, Barry wrote:
> >From: Mike Frysinger
> >>On Tue, Sep 15, 2009 at 23:49, Barry Song wrote:
> >>> Even though CONFIG_GENERIC_HARDIRQS is almost always "y", in case
> >>> CONFIG_GENERIC_HARDIRQS is "n" not "y", threaded_irq will become
> >>> original irq, drivers will not work. So is it necessary to check the
> >>> dependence of GENERIC_HARDIRQS while using threaded_irq?
> >>
> >>when is GENERIC_HARDIRQS not "y" ?  a quick check shows only s390/m68k
> >>dont set it to "y" in their arch Kconfig ?  s390 isnt going to use any
> >>of these drivers, and m68k will eventually update (m68knommu already
> >>has !?).
> >
> > SPARC32 is "n" too. I am not caring about only these several drivers. I just want to find whether that can be a generic problem while using threaded_irq in any driver.
> 
> SPARC32 too is dead, so dont sweat it.  it's safe to assume
> GENERIC_HARDIRQS is "y" in the code we write like these input drivers.

I agree here.

-- 
Dmitry
