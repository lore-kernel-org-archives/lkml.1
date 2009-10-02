Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZJBVlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZJBVlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZJBVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:41:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZJBVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:41:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
Date: Fri, 2 Oct 2009 23:42:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910021917.31509.rjw@sisk.pl> <b637ec0b0910021437l5a011f13qfa4dd541607a6dfb@mail.gmail.com>
In-Reply-To: <b637ec0b0910021437l5a011f13qfa4dd541607a6dfb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910022342.47977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Fabio Comolli wrote:
> Hi.
> 
> On Fri, Oct 2, 2009 at 7:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday 02 October 2009, Fabio Comolli wrote:
> >> Hi.
> >> I suppose this is still valid. I had to work around it by rfkill-ing
> >> the device during the suspend process and reenabling at resume time.
> >
> > Thanks for the update.
> >
> >> I can try to reproduce it with 2.6.31.1 if you want it.
> >
> > In fact I'm more interested in whether or not it's still present in the Linus'
> > tree.
> >
> 
> Well, I just tried 2.6.32-rc1-git3 and I have to say that it's mostly
> useless with my eeepc. The warning didn't show up after resume but it
> was impossible to reassociate with my AP and after some tentative the
> screen went blank.
> 
> I was able to poweroff the netbook using the power button but I'm a
> little scared to try again.

It shouldn't kill the system cold dead, so as long as you have your data
backed up, you can do some debugging IMHO.

> Maybe I'll try with -rc3 or something.

I guess you should report the issues you have at the moment.  Then, it's
actually more likely that someone will take care of fixing them.

Thanks,
Rafael
