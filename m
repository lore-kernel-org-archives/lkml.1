Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbZEGT2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbZEGT2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZEGT1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:27:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZEGT1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:27:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Thu, 7 May 2009 21:27:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Matt Price <moptop99@gmail.com>, linux-kernel@vger.kernel.org,
       Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905072022.15202.rjw@sisk.pl> <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
In-Reply-To: <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072127.11995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Fabio Comolli wrote:
> On Thu, May 7, 2009 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday 07 May 2009, Matt Price wrote:
> >> On Thu, May 7, 2009 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Thursday 07 May 2009, U Kuehn wrote:
> >> >> Pavel Machek wrote:
> >> >> >> T
> >> > Also, as you can see from my previous message, I'm not a big fan of fighting
> >> > over this once again.  Lets try to work together to do something productive
> >> > instead, shall we?
> >> >
> >>
> >> thank you rafael.  i would really like to see the fighting stop, too.
> >> Perhaps the best palce to start would be to look directly at the
> >> patches and, if there are weaknesses, discuss how to improve them?
> >
> > Yes, I've talked about that already with Nigel and there's a kind of a plan.
> >
> 
> Well, if I may jump in I suggest you start with the full-memory image
> functionality. This is in my opinion the biggest advantage in tuxonice
> vs. uswsusp.

In fact I agree, but there's a catch.  The way in which TuxOnIce operates LRU
pages is based on some assumptions that may or may not be satisfied in future,
so if we decide to merge it, then we'll have to make sure these assumptions
will be satisfied.  That in turn is going to require quite some discussion I
guess.

We'll see how the things work out.

Thanks,
Rafael
