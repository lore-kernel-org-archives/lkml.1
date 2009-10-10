Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbZJJOdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbZJJOdC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 10:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbZJJOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 10:33:00 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:49105 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520AbZJJOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 10:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=U1kwPVA7HqJow1qjgdwXWL1vPithpB1VjmrBGTZQgjgzBhEL8N2GGlyutK4pLRo/C5
         nM4c+p+e8PKfKZ5qXd+NHggEwcr74qtfZeF+tk2MBFI9QA5JFrVsQFbUVkk7Up9MDNiI
         7FvlKzEvCsahiGpSkY4YHdk7Ih+slzBTB/Z9w=
Subject: Re: [PATCH] CS5535: Remove the X86 platform dependence of
 SND_CS5535AUDIO
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       loongson-dev@googlegroups.com
In-Reply-To: <20091009005318.7174938c@mycelium.queued.net>
References: <1255059842-12160-1-git-send-email-wuzhangjin@gmail.com>
	 <1255060287.16819.1.camel@falcon>
	 <20091009005318.7174938c@mycelium.queued.net>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sat, 10 Oct 2009 22:32:14 +0800
Message-Id: <1255185134.6883.20.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 2009-10-09 at 00:53 -0400, Andres Salomon wrote:
> On Fri, 09 Oct 2009 11:51:27 +0800
> Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> 
> > On Fri, 2009-10-09 at 11:44 +0800, Wu Zhangjin wrote:
> > > There is no platform dependence of SND_CS5535AUDIO before 2.6.31,
> > > Not sure who have touched this part, but SND_CS5535AUDIO is at least
> > > available on Loongson family machines, so, Remove the platform
> > > dependence directly.
> > > 
> > > Reported-by: rixed@happyleptic.org
> > > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > > ---
> > >  sound/pci/Kconfig |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> > > index fb5ee3c..75c602b 100644
> > > --- a/sound/pci/Kconfig
> > > +++ b/sound/pci/Kconfig
> > > @@ -259,7 +259,6 @@ config SND_CS5530
> > >  
> > >  config SND_CS5535AUDIO
> > >  	tristate "CS5535/CS5536 Audio"
> > > -	depends on X86 && !X86_64
> > 
> > or use this?
> > 
> > 	depends on (X86 && !X86_64) || MIPS
> > 
> > Regards,
> > 	Wu Zhangjin
> > 
> 
> 
> I'd say just remove the arch dependency (and make sure it builds and
> doesn't obviously explode w/ x86-64). There's no need for it, afaict.
> It's been there since at least 2005 (git commit 230b5c1a).
> 

Just checked the SND_CS5536AUDIO(=y and =m) option with ARCH=x86_64, no
compiling warnings & errors, but I don't have such a chip in a x86-64
machine, so, did not test the kernel yet.

Regards,
	Wu Zhangjin

