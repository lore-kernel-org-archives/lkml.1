Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbXD2Nga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbXD2Nga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbXD2Nga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:36:30 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:17119 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbXD2Ng2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:36:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bbtzTKiy1NgCelA4alZo+lEqovAp7n+DjAvnlu5NU2qFzKKl3s/wmDC0C3+CMmsSsOM0Tcg0uReXJxhDbxRayGE/I/seURw7RkUkqS3H7OeMRNlLonkKOB3W/NXNKNrsYE7Mu0JifBQbEIgWCWDm7yCKi0C802SxQBtosF1LpSU=
Message-ID: <6bffcb0e0704290636k3cea128ag44d7d6c9688a4e20@mail.gmail.com>
Date: Sun, 29 Apr 2007 15:36:26 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0704251602x74e01dcbvf1d6eea565e3bbc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
	 <200704252257.41950.ak@suse.de>
	 <6bffcb0e0704251440l6149b50creafd4845c131be09@mail.gmail.com>
	 <200704260007.12843.ak@suse.de>
	 <6bffcb0e0704251602x74e01dcbvf1d6eea565e3bbc5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/04/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 26/04/07, Andi Kleen <ak@suse.de> wrote:
> > On Wednesday 25 April 2007 23:40:51 Michal Piotrowski wrote:
> > > On 25/04/07, Andi Kleen <ak@suse.de> wrote:
> > > >
> > > > > Maybe because it's P4 HT?
> > > >
> > > > Shouldn't make a difference.
> > > >
> > > > Can you please: apply the latest patch from
> > > >
> > > > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share
> > > >
> > > > to a 2.6.21-rc7 kernel and then send me a full boot log?
> > >
> > > Now everything looks OK
> > > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/git-dmesg
> >
> > Does it also work when you revert the sched-clock-share patch in Andrew's broken-out
> > directory from mm and then apply my patch? (just to check there is not a bad interaction
> > with other mm changes)
>
> I dropped
> x86_64-mm-sched-clock-share.patch
> x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
> fix-x86_64-mm-sched-clock-share.patch
>
> The bug still appears
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/mm-dmesg2
>
> I can bisect it in Friday.

s/Friday/Sunday

GOOD
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
BAD

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
