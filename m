Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYF1EYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYF1EYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYF1EY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:24:28 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:27583 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751426AbYF1EY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:24:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=UJLcuQ3Rx4luaAS6ytkjfwTZBqDe+M468Hu3HZmkWjL5+Go/sC0slPjqHejx4lXoVlyl29uMBlLACD06pkTqf6Pc1MOQcKHYcG6ntogWOhlHUpgN+sSFqrTHPEtK5XMuz/reBQictMB2gufgcHY3MTvmvvNifBp2BLYI1zvd+OE=;
X-YMail-OSG: JnMifaQVM1kzPeKMht.bgE3566M51nlJ9UAZUxbSXIxZaRG910lS.XON5tyckNW37PynI3qUmPQW9WQiukFY0.hIO6rOTWkGIX36mts78C1f2AErXHVmaha59IwMkaCKmg--
Date: Fri, 27 Jun 2008 21:24:26 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 5/13] EDAC mpc85xx fix pci ofdev
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Jiang <djiang@mvista.com>,
       bluesmoke-devel@lists.sourceforge.net
In-Reply-To: <20080627210218.84b96465.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <615296.13082.qm@web50104.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 27 Jun 2008 20:53:35 -0700 (PDT) Doug Thompson <norsk5@yahoo.com> wrote:
> 
> > 
> > --- Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Fri, 27 Jun 2008 12:13:13 -0600
> > > dougthompson@xmission.com wrote:
> > > 
> > > > From:	Dave Jiang <djiang@mvista.com>
> > > > 
> > > > Applied to linux-2.6.26-rc5-mm3
> > > > 
> > > > Converting PCI err device from platform to open firmware of_dev to comply with
> > > > powerpc schemes.
> > > 
> > > This one doesn't apply due to later changes which should be in 2.6.26-rc8.
> > > 
> > 
> > 
> > mmm, doesn't apply to the -mm3?  
> > 
> > I knew it didn't apply to the 2.6.26-rc5 because there was a patch in the -mm3 which modified
> the
> > same code. I assumed that patch would remain in the -mm tree until 2.6.27, therefore I didn't
> try
> > the -rc8 code base.  
> > 
> > I applied it 3 times to different 2.6.26-rc5-mm3 trees. The first time there was a problem,
> but
> > did new 2.6.26-rc5 trees with a -mm3 and the last 2 times it worked. That puzzled me.
> > 
> > interesting.
> 
> I suspect there was gregstuff in rc5-mm3 which got dropped later on so
> I don't have it any more.
> 
> > ok will resubmit later when we get a newer -mm update
> 
> Against 2.6.26-rc8 will work.
>

Nope, it failed also. It looks like the reject I got when I tried it on bare 2.6.26-rc5. There was
a patch in -mm3 on EDAC that modified multiple of the following code:

pdev->dev.bus_id references to a dev_name(&pdev->dev)

-mm3 is what dave used for his basis.

Since the -rc5-mm3 patch was broken (the kernel OOPs), I extracted the EDAC patch from that into a
simple patch I applied to -rc5 and then applied my patch set and run that kernel to verify it
worked. I just applied that same mini-mm patch to -rc8 and Dave's patch applied fine. Without that
mini-mm3 patch, it work apply

doug t


W1DUG
