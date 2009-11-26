Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZKZCOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZKZCOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 21:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZKZCOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 21:14:11 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:46436 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZKZCOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 21:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aSyquzYboCFPVAfwAIo9EUi5lCispRTK0jFmSlkXtMAVisWFH8SF+a9xshYNTTQ+ml
         3jhG2ackQAgX1ue5EPIolaNMhCXIHtU70XbyK/67J3nKZwoSpeDvipqs01j0hpelMjGb
         GWbzSysuc+oJxG4jXksspTRuKbSDm0Xme1Jpo=
Date: Wed, 25 Nov 2009 18:14:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mikko Vinni <mmvinni@yahoo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: keyboard leds not restored after s2ram in
	2.6.32-rc6-00166-g799dd75
Message-ID: <20091126021409.GB23079@core.coreip.homeip.net>
References: <761296.29412.qm@web58402.mail.re3.yahoo.com> <20091111095218.GA3654@core.coreip.homeip.net> <800885.42568.qm@web58401.mail.re3.yahoo.com> <20091111215029.GA13390@core.coreip.homeip.net> <282630.26689.qm@web58403.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <282630.26689.qm@web58403.mail.re3.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 12:08:39AM -0800, Mikko Vinni wrote:
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> > > I did some tests suspending with the caps lock actually on, and it seems that
> > > in that case the user might still be confused (caps lock is on but led is 
> > off).
> > > At least on this machine this patch doesn't affect this theoretical problem
> > > either way (2.6.31 behaves similarly), so it is ok.
> > > 
> > 
> > Umm... so you are saying that even with .31 if you suspend with capslock
> > on it is off when you resume? Does it happen only in X or in console as
> > well?
> 
> It seems I judged a bit too early.
> In console, both 2.6.31 and .32-rc6+your patch:
> - suspending both with capslock on and off works as expected (same state in mode
> and led after resume)
> 
> In X, both  2.6.31 and .32-rc6+your patch:
> - suspending both with capslock on and off works; after resume same state
> (typing procudes capital letters if capslock was on) and led shows the caplock
> state
> - if the capslock is on after resume, and I press shift before capslock key, the led
> turns off but typing still produces capital letters. This, I think, is strange. This did
> not happen in console, neither does pressing shift usually turn off the led.
> 
> So, apart from the minor nuisance of the shift key turning off the capslock led in X
> even if typing still produces capital letters, everything seems to work as expected.
> 

OK, so from this description it looks like an issue in X, not in the
kernel.


Thanks.

-- 
Dmitry
