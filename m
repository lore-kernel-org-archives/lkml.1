Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbYDPVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbYDPVrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbYDPVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:45:05 -0400
Received: from web52506.mail.re2.yahoo.com ([206.190.48.189]:40726 "HELO
	web52506.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933433AbYDPVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:45:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xbkhv83NxHV7tHuGuATZJyrOp272ovDAUlhtFSjrWkcS6O4wZBon8dgoYmCxt9hi7LXs1MdSqBEI+F/LT2myRkEzb5CA7Q14iszGO5xLpB97wOXKrp/hHo7rcDjjRUoK22rEjHKZ/JZpe0reMGprGfTjqbQI/ovPFBf8MIEAR+g=;
X-YMail-OSG: P9K0VQMVM1kE434ba7osKZmdqRm3SrAtLJRRT5M4g6WWQWX5uOhrQMbDpCASagoMxEse4aDwDp.lHMA96B4a4GFTE7uooq8-
Date: Wed, 16 Apr 2008 14:44:56 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: AMD Quad Core clock problem?
To: Bart Van Assche <bart.vanassche@gmail.com>,
       Chris Snook <csnook@redhat.com>
Cc: Marc Perkel <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <e2e108260804142311r7ca31d29m7221ca8935a79f35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <414144.49021.qm@web52506.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Bart Van Assche <bart.vanassche@gmail.com> wrote:

> On Mon, Apr 14, 2008 at 9:16 PM, Chris Snook
> <csnook@redhat.com> wrote:
> > Marc Perkel wrote:
> >
> > > My best guess at this time is that the drift of
> this
> > > computer using the quad core is so great that
> the ntpd
> > > can't get in sync. Is there any way to make ntpd
> more
> > > agressive by setting something in ntp.conf?
> > >
> >
> >  ntp can correct for 500 ppm drift, which equates
> to 1.8 seconds per hour.
> > Beyond that you need to run ntpdate or ntpd -gq
> from cron to correct it.
> 
> It's better to correct the clock frequency once with
> the tickadj or
> adjtimex, so you don't have to add ntpdate to cron
> and you can still
> run ntpd.
> 
> Bart.
> 

ok - thanks. How do I do that?


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
