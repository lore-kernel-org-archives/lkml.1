Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXICVYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXICVYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbXICVYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 17:24:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:23489 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbXICVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 17:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=INurYWoRwlFOM+q1zyny+5q1/Ztyud74DBd1ecozxG90IeGHKrXMtZG9HAIdueENeJqEryXhq+gvQkOpYpoZrz4I9ZgJqjCS6uKKf6zfKJlAHPu8HcaGCcrXpxXVyK+OaAv0CWwMc+6MVyxl5jFNQZkwG4u8chP6XWrMEerc2+E=
Message-ID: <5a4c581d0709031424y6b5c25dob23e3bf7230716cd@mail.gmail.com>
Date: Mon, 3 Sep 2007 23:24:11 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: Linux 2.6.23-rc5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Prakash Punnoor" <prakash@punnoor.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46DC5347.1060106@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org>
	 <200709020954.08285.prakash@punnoor.de>
	 <200709021149.42733.rjw@sisk.pl> <46DC5347.1060106@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 2 September 2007 09:54, Prakash Punnoor wrote:
> >> Hi,
> >>
> >> 2.6.23-rc5 locks up hard (Magic Syskeys won't even work) after a few minutes
> >> of work on x86_64. 2.6.23-rc4 was fine. I'll try git-bisect to find out what
> >> is causing trouble. Yes, I am using nvidia binary but it didn't make troubles
> >> since ages... When I found the bugger, I'll try whether it works w/o nvidia
> >> binary.
> >
> > Just for the record, I'm running -rc5 on two x86_64 boxes without any visible
> > issue.
> >
> > I don't use any binary graphics drivers, though.
>
> 2.6.23-rc5 dies here random[1] too .. on 2 Dell boxes ( i686 not x86_64 here ) which I upgraded to rc5 yesterday.
>
> When dies 'Caps Lock and Scroll Lock' blinks and the box lockups hard .. rc4 got an 7 days uptime on both with the same config ,
> kernel compiled with same gcc/glibc/binutils etc.

[snip]

This one has bitten many of us :)

http://lkml.org/lkml/2007/9/2/219

--alessandro

 "I can't believe you if I can't hear you"

   (Editors, 'Smokers Outside The Hospital Doors')
