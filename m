Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbXDYXCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbXDYXCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbXDYXCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:02:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:10223 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbXDYXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qi8eg3rT99EWlLljchkuQErIO/ivHaop5cAgkZaGdSr2EyPXXsQqFaD3lpIYqlo2wcYKk3xtUNls+f08AAFBIeGp0es6LwazrFrkA1WrK604Xm7b6H9GMM2S8LjAnIFzxc/r/ANFIk/ApHZNU2mkiuJrr3Zk90DOUaHOBbwlsD4=
Message-ID: <6bffcb0e0704251602x74e01dcbvf1d6eea565e3bbc5@mail.gmail.com>
Date: Thu, 26 Apr 2007 01:02:34 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704260007.12843.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
	 <200704252257.41950.ak@suse.de>
	 <6bffcb0e0704251440l6149b50creafd4845c131be09@mail.gmail.com>
	 <200704260007.12843.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 25 April 2007 23:40:51 Michal Piotrowski wrote:
> > On 25/04/07, Andi Kleen <ak@suse.de> wrote:
> > >
> > > > Maybe because it's P4 HT?
> > >
> > > Shouldn't make a difference.
> > >
> > > Can you please: apply the latest patch from
> > >
> > > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share
> > >
> > > to a 2.6.21-rc7 kernel and then send me a full boot log?
> >
> > Now everything looks OK
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/git-dmesg
>
> Does it also work when you revert the sched-clock-share patch in Andrew's broken-out
> directory from mm and then apply my patch? (just to check there is not a bad interaction
> with other mm changes)

I dropped
x86_64-mm-sched-clock-share.patch
x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
fix-x86_64-mm-sched-clock-share.patch

The bug still appears
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/mm-dmesg2

I can bisect it in Friday.

>
>
> Thanks,
> -Andi
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
