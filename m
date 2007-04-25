Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbXDYWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbXDYWH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXDYWH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:07:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:43922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbXDYWH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:07:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Date: Thu, 26 Apr 2007 00:07:12 +0200
User-Agent: KMail/1.9.6
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net> <200704252257.41950.ak@suse.de> <6bffcb0e0704251440l6149b50creafd4845c131be09@mail.gmail.com>
In-Reply-To: <6bffcb0e0704251440l6149b50creafd4845c131be09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704260007.12843.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 23:40:51 Michal Piotrowski wrote:
> On 25/04/07, Andi Kleen <ak@suse.de> wrote:
> >
> > > Maybe because it's P4 HT?
> >
> > Shouldn't make a difference.
> >
> > Can you please: apply the latest patch from
> >
> > ftp://firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share
> >
> > to a 2.6.21-rc7 kernel and then send me a full boot log?
> 
> Now everything looks OK
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-25-02-49/git-dmesg

Does it also work when you revert the sched-clock-share patch in Andrew's broken-out
directory from mm and then apply my patch? (just to check there is not a bad interaction
with other mm changes)


Thanks,
-Andi
