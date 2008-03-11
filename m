Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbYCKETi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbYCKETi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYCKETb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:19:31 -0400
Received: from n54.bullet.mail.sp1.yahoo.com ([98.136.44.32]:20840 "HELO
	n54.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751014AbYCKETb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:19:31 -0400
X-Yahoo-Newman-Id: 847861.51860.bm@omp425.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LMktLol+P5PDOwuB1N1XD/8a4Dpv7cvxyDAQmgZ6RGIXzJ1BA2+KaSI7+dt8IqBLDdDB+TMyYz1VBIQFtOfss7UdDmB2haf3L0jBdLHumUjECnmXd26iUbL8KCVLPfDPltP1Jrz+scnbTbdc/8wGXp69SST19alJiPNGFlr+6hU=  ;
X-YMail-OSG: AWP2NWMVM1lIjq6SQIAnTD9gR9F5SByl5vnNFXMa57qbGoIH13yGYE4PYRndvTXSB57WN_x_CQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: inotify fixes in stable
Date: Tue, 11 Mar 2008 15:12:37 +1100
User-Agent: KMail/1.9.5
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx> <20080310215755.7e920738@mjolnir.drzeus.cx> <20080310211346.GA6622@kroah.com>
In-Reply-To: <20080310211346.GA6622@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111512.37605.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 08:13, Greg KH wrote:
> On Mon, Mar 10, 2008 at 09:57:55PM +0100, Pierre Ossman wrote:
> > On Mon, 10 Mar 2008 13:31:16 -0700
> >
> > Greg KH <greg@kroah.com> wrote:
> > > On Mon, Mar 10, 2008 at 08:36:58PM +0100, Pierre Ossman wrote:
> > > > The system is an OpenSuse 10.3 system, so 2.6.22.y would be the
> > > > interesting one. I'll see if I can get a custom kernel in there (I've
> > > > been unable to reproduce the problem outside a production
> > > > environment).
> > >
> > > 2.6.22.y is no longer being released by me, so it isn't interesting to
> > > me at all :)
> >
> > Oh? You made a release just 13 days ago, so I figured you were still
> > giving it some love.
>
> In that release, I said it was going to be my last.
>
> > > What about 2.6.24?  Is this still an issue there?
> >
> > Judging from the kernel bugzilla, it would seem so.
> >
> > But in my specific case, the guy on site was going to try an updated
> > kernel from Suse's build system. I'll probably now the results
> > tomorrow or the day after that.
>
> Please let us know.

The messages should actually be harmless. There is a race in the debug
code that can trigger them. But I wouldn't object to the patches going
to -stable...

