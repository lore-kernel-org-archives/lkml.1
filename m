Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXIKWUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXIKWUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 18:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXIKWUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 18:20:33 -0400
Received: from web90412.mail.mud.yahoo.com ([216.252.100.164]:49074 "HELO
	web90412.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751534AbXIKWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 18:20:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TsBgVr4zKMhU+Y2PiZoQrv9glCkisH/OeJPs5gRZsfnP29YvGn440gYPl8heHzK1Rf4nybkYJDzr4zni/N5wmKwMjVzgs/I/t3VKnsKQuCfS/yz9bfL1rN9lAaEW8US3pcD1OkadPF45MpH4GEx9v4trHY2raIyv6nyxYSB7FWg=;
X-YMail-OSG: QU3rbJoVM1nUHRz2gwjDI7LwJc9UNpy1S6suV3jOkFTsMgRwp8F_HPiq3AVK_0lY8g.O3cpG3CmDxMvYpUcQjgDGISQlzFanvEDw
Date: Tue, 11 Sep 2007 15:20:32 -0700 (PDT)
From: James Corey <ploversegg@yahoo.com>
Subject: Re: sk98lin for 2.6.23-rc1
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Cc: Kyle Rose <krose@krose.org>, Bill Davidsen <davidsen@tmr.com>,
       James Corey <ploversegg@yahoo.com>, Rob Sims <lkml-z@robsims.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070911100526.6aa5d463@oldman>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <176747.59824.qm@web90412.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> On Sun, 9 Sep 2007 13:13:26 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sat, Sep 08, 2007 at 10:42:20PM -0400, Kyle
> Rose wrote:
> > > 
> > > > You are a regular reader of linux-kernel, and
> therefore the sk98lin 
> > > > removal can hardly be a surprise for you. If
> you prefer whining over 
> > > > helping to improve the kernel that's your
> choice...
> > > >   
> > > In my case the issue is simply one of
> practicality: I cannot go to the
> > > data center 5 times per day to reboot my colo
> box.  Therefore, I run
> > > sk98lin.  It's really that simple.
> > 
> > When did you report this bug the first time?
> > 
> > What we need is that people when testing a new
> kernel they plan to use 
> > test the new drivers *and report the bugs if they
> run into any*.
> > 
> > What could we have done so that you reported your
> bug without removing 
> > the sk98lin driver?
> > 
> > > Kyle
> > 
> > cu
> > Adrian
> 
> 
> There are several different problems in this thread:
> 1. The removal of old sk98lin driver caused some
> users to be forced to use
>     skge. These users have uncovered issues with the
> dual port fiber based versions
>     of the board.  
>     Short term: The sk98lin driver should be
> restored to previous state, 
>        and the PCI table should be used to limit the
> usage to only fiber systems.
>        If Adrian doesn't do it, I'll do it when I
> return from Germany.
>     Long term: I have fiber based board (thanks
> ebay) on the way to resolve
>        skge bug.
> 
> 2. Sky2 driver has it's own fiber based problems. 
> Solve these after skge fiber.
> 
> 3. Sky2 doesn't have as many workarounds for
> hardware problems as vendor sk98lin
>     driver.
> -


Hm, hope I didn't trigger a religious debate. When
you get to the point of working on the SKY2 driver
problem with DGE-550SX (Syskonnect SK-9S81) also
known as the "hw csum failure" issue, I'll be 
glad to test a patch or take debug data. Til then,
I'll stay out of the way.

-J





      ____________________________________________________________________________________
Shape Yahoo! in your own image.  Join our Network Research Panel today!   http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 


