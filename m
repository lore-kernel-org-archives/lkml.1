Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZIPE0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZIPE0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbZIPE0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:26:13 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:41361 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZIPE0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VhPjZxwAJ/85TIIfSMDuJf3pw6eN9/oo7jRfm/Yr+k4YOaSd8lj7GR+ZcGtSEJMX1d
         bXKQMLZoMrum1ymkfQ+M86jwQ03EcXH+cWP6PDj/j8XJoMCfAA/VOcYw/9/+MQPBPHv6
         dOwr6iDQs9vsEG9oLMRyW4dNJ8EmS4llaywlM=
MIME-Version: 1.0
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA04BEE48B@chinexm1.ad.analog.com>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> 
	<20090915062050.GB10232@core.coreip.homeip.net> <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com> 
	<20090915162655.GB29241@core.coreip.homeip.net> <3c17e3570909152049nd801aeds3915e5889d6181f0@mail.gmail.com> 
	<8bd0f97a0909152103m4848fe9ayb5835a6844ea4ca1@mail.gmail.com> 
	<0F1B54C89D5F954D8535DB252AF412FA04BEE48B@chinexm1.ad.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 00:25:56 -0400
Message-ID: <8bd0f97a0909152125l29683107h93837b7388a9d20f@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] input/keyboard: add ADP5588 
	QWERTYI2C Keyboard Input device driver
To: "Song, Barry" <Barry.Song@analog.com>
Cc: Barry Song <21cnbao@gmail.com>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 00:18, Song, Barry wrote:
>From: Mike Frysinger
>>On Tue, Sep 15, 2009 at 23:49, Barry Song wrote:
>>> Even though CONFIG_GENERIC_HARDIRQS is almost always "y", in case
>>> CONFIG_GENERIC_HARDIRQS is "n" not "y", threaded_irq will become
>>> original irq, drivers will not work. So is it necessary to check the
>>> dependence of GENERIC_HARDIRQS while using threaded_irq?
>>
>>when is GENERIC_HARDIRQS not "y" ?  a quick check shows only s390/m68k
>>dont set it to "y" in their arch Kconfig ?  s390 isnt going to use any
>>of these drivers, and m68k will eventually update (m68knommu already
>>has !?).
>
> SPARC32 is "n" too. I am not caring about only these several drivers. I just want to find whether that can be a generic problem while using threaded_irq in any driver.

SPARC32 too is dead, so dont sweat it.  it's safe to assume
GENERIC_HARDIRQS is "y" in the code we write like these input drivers.
-mike
