Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXIBUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXIBUii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXIBUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:38:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:40360 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXIBUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cMYTMGXsax4+Ajvl4qg1dofDmVE33nwxZ54is21NLng+6M2H66qZWZpQaVsQM1/GITtG9I+l9lJUu/cJWC1RDLRggoWs3cjimKraKYrhvNnGD/0BrhiWqPuosdfoyhrXmyam1oZq09qTJpHuIZZiWWiO5rkCix+dg/56TW2ag84=
Message-ID: <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
Date: Sun, 2 Sep 2007 22:38:28 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "charles gagalac" <charles.gagalac@gmail.com>
Subject: Re: Hang in 2.6.23-rc5
Cc: "daryll q" <daryll_26m@yahoo.com.ph>, linux-kernel@vger.kernel.org
In-Reply-To: <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
	 <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> On 9/2/07, daryll q wrote:
> > Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
> >
> >  System hangs (caps lock and scroll lock leds are both flashing).
> >
> >  It *randomly* happens but most of the time during after login to KDE.
> >
> >  I have not investigated it yet because I have not tried doing it  before.
> >
> >  Also the system is really not responding so I can't do much.. Just
> >  hope it blue screen so I can send the error code easily :)
>
> i experienced hangs, with the flashing caps and scroll locks as you've
> described, in a few of my later pulls prior to rc5.  i couldn't
> reproduce the hangs and my logs didn't show evidence of a problem.  my
> system under rc5, so far, hasn't hung on me.
>
> charles

Oh, I thought I was the only one. I also had a single hang+flashing
 Caps & Scroll Lock with -rc5, but haven't had one since.

I had VMWare Player modules loaded at the time though, and I
 recently rebuilt them with the any-any-patch-113 (earlier versions
 would not build with very recent kernels).

-rc4-git2 and -git3 never hung even with VMWare modules loaded.

So I disabled the autoload of VMWare stuff. The problem has not
 reproduced so far. My system is a Dell D610, running updated
 Fedora 7, with Intel 915GM video chipset.

--alessandro

 "I can't believe you if I can't hear you"

   (Editors, 'Smokers Outside The Hospital Doors')
