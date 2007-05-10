Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbXEJVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbXEJVea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758846AbXEJVeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:34:23 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:32433 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755932AbXEJVeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:34:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DaXA2QmITDtNWFaWWT56x3a2Y566qHqsMaGrRxXwzK43EebDWdKWEIIhOCfbHHkyng9zXLWwZITfG4HayEHZgljIxaGAGwdwU+Zd9smWaqVA232K+Xe5CZBsmCVLxvQsgodTS9sr28QMdQovrvfjfEhoAcYPL0Vr19KkKbJzAvc=  ;
X-YMail-OSG: YdX3CvYVM1k6sG_lJrtfYgMyxYsykz2LBNuP7AxiDNfsNNHL
From: David Brownell <david-b@pacbell.net>
To: tglx@linutronix.de
Subject: Re: drivers/mtd/devices/at91_dataflash26.c
Date: Thu, 10 May 2007 14:34:08 -0700
User-Agent: KMail/1.9.6
Cc: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>,
       dwmw2@infradead.org, Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704271812.26392.david-b@pacbell.net> <200705101307.19794.david-b@pacbell.net> <1178831974.22481.9.camel@localhost.localdomain>
In-Reply-To: <1178831974.22481.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200705101434.08996.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007, Thomas Gleixner wrote:
> David,
> 
> On Thu, 2007-05-10 at 13:07 -0700, David Brownell wrote:
> > On Friday 27 April 2007, David Brownell wrote:
> > > On Friday 27 April 2007, Hans-Jürgen Koch wrote:
> > > 
> > > > > 	 the m25p80 driver
> > > > > was pretty close to working with those Atmel devices too ...
> > > > > most of the commands are identical.
> > > > 
> > > > Thanks for that hint, I'll have a look at the data sheet.
> > 
> > Any progress on that?  I looked again, and yes most commands
> > are identical...
> >
> > So 340ea370c2ce89d1c15fbf785460f2f74314ce58 should be reverted.
> 
> We look into this and fix the problem. There is no need to revert it
> right now. It does no harm and we remove it with the merge into the
> m25p80 driver, ok ?

Sounds like a plan ... but I'd still revert ASAP.

Either way, I'd hope it's all resolved before we
get very far into the 2.6.22-rc series.

- Dave
