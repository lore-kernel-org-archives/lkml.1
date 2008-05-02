Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYEBBje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYEBBje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYEBBjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:39:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50010 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbYEBBjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:39:22 -0400
Subject: Re: Sharing disks amoung multiple software RAIDs
From: Kasper Sandberg <lkml@metanurb.dk>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Alex Davis <alex14641@yahoo.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0805010849380.20043@p34.internal.lan>
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
	 <alpine.DEB.1.10.0805010849380.20043@p34.internal.lan>
Content-Type: text/plain
Date: Fri, 02 May 2008 03:39:19 +0200
Message-Id: <1209692359.16523.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 08:50 -0400, Justin Piszcz wrote:
> 
> On Thu, 1 May 2008, Alex Davis wrote:
> 
> > Is this a bad thing? I'm guessing that it is, but I want independent
> > confirmation before I spoke to someone I know who's doing this.
> >
> > Thanks
> >
> >
> >      ____________________________________________________________________________________
> > Be a better friend, newshound, and
> > know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> What is the use case, why would you want to do that?
> I have seen people on the list do it before, for example are you going to 
> be utilizing both raids at the same time?  If so, I would advise against 
> it.
> 
> What is the reasoning?

I do this!

is this really bad? i would surely like a list of reasons why..

I do it because.. well.. first off, it allows me to have /boot on
different raidlevel than / or /home without extra disks.
secondly, it allows me to with the same disks use different
filesystems.. for instance, it allows me to have /home encrypted with
dm-crypt, while still raided.. Not that i would mind encrypting /
and /home as 1 partition, but it creates a whole slew of issues with
having to create initrd and stuff..

I realize that performance probably suffers abit from this, but well..
is there any stability or security wise risk? i mostly use raid1 and
raid5 only..

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

