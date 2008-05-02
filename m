Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbYEBBwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbYEBBwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYEBBv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:51:57 -0400
Received: from web50212.mail.re2.yahoo.com ([206.190.39.176]:32069 "HELO
	web50212.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750975AbYEBBv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:51:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=YCTgknXjqpctpJpTXpRXeZ3JtbNizqqpqCftNu62F5TLFXgsY5glQJTKnc6BGd0S6FZq/ESVpKu638xmjze6YlPet1bwh776svVZBH0ySaaK/shoIOsrf/mACVYai+6WdLSvi74pZmIJf/WeG8bzYWG4y4OeoB2sYkY7TbKxD48=;
X-YMail-OSG: 5yghumAVM1kiSS63KRhdiWM8QWs9Nka0bNN9DbpbFrC_JyYcUxTgcfqGlewxeEh1D5z8l61Q4gQU9llfNrrrXAm49Pa8gCvEvNEoR81RKcLdVeh8T2pzGUBNyg--
X-Mailer: YahooMailWebService/0.7.185
Date: Thu, 1 May 2008 18:51:54 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: alex14641@yahoo.com
Subject: Re: Sharing disks amoung multiple software RAIDs
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Kasper Sandberg <lkml@metanurb.dk>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1209692359.16523.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <73000.21239.qm@web50212.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 5/1/08, Kasper Sandberg <lkml@metanurb.dk> wrote:

> From: Kasper Sandberg <lkml@metanurb.dk>
> Subject: Re: Sharing disks amoung multiple software RAIDs
> To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
> Cc: "Alex Davis" <alex14641@yahoo.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, May 1, 2008, 9:39 PM
> On Thu, 2008-05-01 at 08:50 -0400, Justin Piszcz wrote:
> > 
> > On Thu, 1 May 2008, Alex Davis wrote:
> > 
> > > Is this a bad thing? I'm guessing that it is,
> but I want independent
> > > confirmation before I spoke to someone I know
> who's doing this.
> > >
> > > Thanks
> > >
> > >
> > >     
> ____________________________________________________________________________________
> > > Be a better friend, newshound, and
> > > know-it-all with Yahoo! Mobile.  Try it now. 
> http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> > > --
> > > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > > the body of a message to
> majordomo@vger.kernel.org
> > > More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > What is the use case, why would you want to do that?
> > I have seen people on the list do it before, for
> example are you going to 
> > be utilizing both raids at the same time?  If so, I
> would advise against 
> > it.
> > 
> > What is the reasoning?
> 
> I do this!
> 
> is this really bad? i would surely like a list of reasons
> why..
> 
> I do it because.. well.. first off, it allows me to have
> /boot on
> different raidlevel than / or /home without extra disks.
> secondly, it allows me to with the same disks use different
> filesystems.. for instance, it allows me to have /home
> encrypted with
> dm-crypt, while still raided.. Not that i would mind
> encrypting /
> and /home as 1 partition, but it creates a whole slew of
> issues with
> having to create initrd and stuff..
> 
> I realize that performance probably suffers abit from this,
> but well..
> is there any stability or security wise risk? i mostly use
> raid1 and
> raid5 only..
> 
I would guess if the RAIDs are heavily used simultaneously it could
cause the disk head actuators to jump around more, causing more wear
and tear.


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
