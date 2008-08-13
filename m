Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYHMOdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYHMOdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYHMOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:33:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:9103 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYHMOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LDFnlH61rkZSlCqOPfKKStmEpxzkXsZbXPp76/awIX9w+/wElTC6MDhkyNwPkZlRsJ
         KezfyC6IzM0S+cg38zA+f0e25zZ9AAh4cZNBv4gKMfJJTQ2TZB3zj5dOsfT1H/sYo1wh
         xeqftPIV3p6LonOQvvofKVhBGS098IdwABc+A=
Subject: Re: Timer unstability on when using C2 and deeper sleep states
	(Dell Latitude XT)
From: Milan Plzik <milan.plzik@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080813130558.GE6995@ucw.cz>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost>  <20080813130558.GE6995@ucw.cz>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 16:33:14 +0200
Message-Id: <1218637994.5250.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On St, 2008-08-13 at 15:05 +0200, Pavel Machek wrote:
> Hi!

  Hello,

  I apologize, I have not seen your reply, the newest update already
describes my situation.

> 
> >   I apologize for replying on my own mail (and also for top-posting, but
> > this information is global update, not exactly fitting any of topics
> > mentioned below).
> > 
> >   After playing for a longer while I found out that the system ends
> > sometimes in state where, in order to do anything useful, I need to
> > press keys on keyboard. Otherwise, the system just stalls and does
> > nothing. I have no idea why does this happen (especially when I know
> 
> I have seen it before with NOHZ problems. Try nohz=off, highres=off ?
> 

  I tried nohz=off; result was stably working system, but the cause
could be that it virtually did not enter any of deeper C states (I also
had HZ configured to 1000, but I'm not sure whether that matters when
calculating efficieny of switching to Cx state). I also tried to disable
hpet at all, and to disable support for high resolution timers in
kernel, but result was the same, IIRC. Unless I wasn't entering C2 or
C3, the system was stable.

	Milan

