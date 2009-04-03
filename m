Return-Path: <linux-kernel-owner+w=401wt.eu-S933759AbZDCVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759AbZDCVBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZDCVAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:00:55 -0400
Received: from relay3.sgi.com ([192.48.156.57]:55987 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751515AbZDCVAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:00:54 -0400
Date: Fri, 3 Apr 2009 16:01:17 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
Message-ID: <20090403210117.GA14582@sgi.com>
References: <f3177b9e0904031302p8aef826u1874a8b9d9af0840@mail.gmail.com> <49D66E83.5070606@inria.fr> <86802c440904031349v31f84f8anf082db7505e60387@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440904031349v31f84f8anf082db7505e60387@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 01:49:27PM -0700, Yinghai Lu wrote:
> On Fri, Apr 3, 2009 at 1:16 PM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> > Chris Worley wrote:
> >> Sorry for an off topic, but I'm hoping somebody can point me in the
> >> right direction of where to direct this question...
> >>
> >> I have an Opteron system where I've seen the HW diagrams, and each of
> >> 4 sockets is directly connected (HT) to two other sockets, and two HT
> >> hops away from a third (i.e. a simple square topology, no X in the
> >> middle).
> >>
> >> Yet, "numactl --hardware" shows but one hop to each socket:
> >>
> >> # numactl --hardware
> >> ...
> >> node   0   1   2   3
> >>   0:  10  20  20  20
> >>   1:  20  10  20  20
> >>   2:  20  20  10  20
> >>   3:  20  20  20  10
> >>
> >> I know this is wrong.
> >>
> >> Who would be the right person (or list) to talk about this?

numactl and libnuma are discussed on
linux-numa@vger.kernel.org

> >>
> >
> > IIRC, the motherboard/BIOS is supposed to report numa distances through
> > the PXM ACPI method. But I have never seen any opteron box do it
> > properly. So you just get 10 for "local" and 20 for "remote". Some
> > Itanium machines however report actual distances.
> 
> for x86 64 bit, we are copying SLIT table and save another copy.
> 
> could provide one /sys interface to make user could modify it...
> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
