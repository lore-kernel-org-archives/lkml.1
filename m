Return-Path: <linux-kernel-owner+w=401wt.eu-S935937AbYEBWFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935937AbYEBWFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbYEBWFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:05:04 -0400
Received: from web50212.mail.re2.yahoo.com ([206.190.39.176]:36293 "HELO
	web50212.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755587AbYEBWFD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:05:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ig7gxUCGItaoVjoKZqEGh0sn2VWhg4rx74RF8BijVkpZMg0FtwzW79e3WuMZDJ40VhpT/eBWtIGXfH2C07sR+hKLwwxy4Ay/3DV2/7yEOTVuPo+E4B+Pq80oJeYgfKOco10WSjJZdwXxHfVuecmbRFxetKrniJEGbxF8SU7Neyo=;
X-YMail-OSG: WezsH.IVM1k4e4bgxCXqnErtbjR35Z39s69lZitLetCzJmJHE_R3Fi3UfXiB7jQ.sz.EJlyJkn5.o22RcXIqMAhUsNCeAy06wUWNkGIC5fzKm5isuDCljA--
X-Mailer: YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 15:04:55 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: alex14641@yahoo.com
Subject: Re: Sharing disks amoung multiple software RAIDs
To: David Greaves <david@dgreaves.com>, Kasper Sandberg <lkml@metanurb.dk>
Cc: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1209764630.7827.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <977930.28629.qm@web50212.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 5/2/08, Kasper Sandberg <lkml@metanurb.dk> wrote:

> From: Kasper Sandberg <lkml@metanurb.dk>
> Subject: Re: Sharing disks amoung multiple software RAIDs
> To: "David Greaves" <david@dgreaves.com>
> Cc: "David Rees" <drees76@gmail.com>, "David Lethe" <david@santools.com>, alex14641@yahoo.com, "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Friday, May 2, 2008, 5:43 PM
> On Fri, 2008-05-02 at 09:25 +0100, David Greaves wrote:
> > Kasper Sandberg wrote:
> > > Im not treating it as a backup, what i want, is
> to make sure that if 1
> > > disk dies, the data is still intact and ill
> hopefully be able to run
> > > with 1 disk till the newly ordered one arrives
> > Probably one of the main design objectives behind
> RAID/md
> 
> Exactly, but once people start saying: "Look how many
> problems people
> post to the thread on
> a weekly basis where people lose their data when md
> rebuilds go bad with
> non-shared disks" i begin to worry..
> 
> > 
> > > So my question remains.. Is md raid1 not suited
> for this need? would it
> > > be safer to run in non-raid1 mode and daily(maybe
> hourly) rsync
> > > everything over to the second disk?
> > 
> > md is 100% guaranteed perfect or your money back...
> > rsync is 100% guaranteed perfect or your money back...
> > your backups are 100% guaranteed perfect or your money
> back...
> > your hard drives are 100% guaranteed perfect or your
> money back...
> > your CPU and RAM are 100% guaranteed perfect or your
> money back...
> > your CPU and PSU fans are 100% guaranteed perfect or
> your money back...
> > 
> > Clearly if you want to panic over reliability you have
> lots of choices :)
> 
> I do not wish to panic, i merely wished to know if linux MD
> is believed
> to work in most cases, or believed to do all sorts of weird
> stuff when
> resyncing :)
> 
> > 
> > David
> > PS, FWIW md has saved my data* countless times over
> the past 'n' years in
> > exactly the scenario you describe.
> 
> It has also been useful to people i know, i just wished to
> be sure :)
> and as Keld Jørn Simonsen and Helge Hafting's comments
> seems to confirm,
> linux md IS nice and stable :)
> 
> and as said, what im looking for isnt an in-box backup
> solution, merely
> safety in case one disk burns :)
> 
> > 
> > *(or more accurately has saved me from having to
> restore my data)

Just to add another data point, I've been using md in RAID 5 configuration for ~3 years with dedicated USB and SATA disks 
(not mixed) and have had disks go bad, and have yet to lose 
any data. Given the 'quality' of high-capacity disks nowadays,
RAIDing them is the right thing to do.


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
