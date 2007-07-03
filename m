Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXGCN1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXGCN1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXGCN1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:27:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbXGCN1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:27:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: Suspend2 is getting a new name.
Date: Tue, 3 Jul 2007 15:34:05 +0200
User-Agent: KMail/1.9.5
Cc: Bill Davidsen <davidsen@tmr.com>, nigel@suspend2.net,
       LKML <linux-kernel@vger.kernel.org>
References: <200707021730.57066.nigel@nigel.suspend2.net> <46894F8F.3070607@tmr.com> <200707030808.26802.nigel@nigel.suspend2.net>
In-Reply-To: <200707030808.26802.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031534.06350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 3 July 2007 00:08, Nigel Cunningham wrote:
> Hi.
> 
> On Tuesday 03 July 2007 05:18:39 Bill Davidsen wrote:
> > Nigel Cunningham wrote:
> > > Hi all.
> > > 
> > > Suspend2's name is changing to "TuxOnIce".
> > > 
> > > This is for a couple of reasons:
> > > 
> > > In recent discussions on LKML, the point was made that the word "Suspend" 
> is 
> > > confusing. It is used to refer to both suspending to disk and suspending 
> to 
> > > ram. Life will be simpler if we more clearly differentiate the two.
> > > 
> > > The name Suspend2 came about a couple of years ago when we made the 2.0 
> > > release and started self-hosting. If we ever get to a 3.0 release, the 
> name 
> > > could become even more confusing! (And there are already problems with 
> people 
> > > confusing the name with swsusp and talking about uswsusp as version 3!).
> > > 
> > > http://www.suspend2.net is still working at the moment, but we'll shift to 
> > > http://www.tuxonice.net over the next while. The wiki and bugzilla are 
> > > already done; email will remain on suspend2.net for a little while and git 
> > > trees will be renamed at the time of the next stable release.
> > > 
> > I guess this is "good news, bad news" time. The good news is that the 
> > "suspend with working resume" project is still active, the bad news is 
> > that making provisions for long term out of mainline operation sounds as 
> > if you have no hope of getting this code into the mainline kernel. :-(
> 
> Let's not turn this into a flamewar, please. This is just a name change, 
> nothing more.
> 
> As far as I know, the desire on Rafael's part and mine is still to get at 
> least some of the functionality merged. The only reason this isn't happening 
> yet is that we're both busy with other aspects of the work. Rafael is 
> focussing on infrastructure issues, I'm focussing on minimising the diff and 
> finishing off cleaning up and adding comments to functions.

That's correct, thanks for saying this!

My first target is to introduce a framework allowing drivers to have different
callbacks for hibernation and suspend.   Unfortunately, that turned out to
require quite a lot of work - and time - to do.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
