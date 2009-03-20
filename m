Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbZCTKM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbZCTKM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZCTKEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:04:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:45210 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbZCTKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dr1DH3fdiZOS2fVAerNYnxnV5WVwvSzomd9eCMmHKgz4hI+lHX0gDp+Jfkhz1MlaYv
         JKZwWj1SKROt6qW2DYkc/bjD9E54bm81do+TNgUfuLu9gPc5+PlpczwMs8WvqRGA1Enj
         mV2hrv3mGygQACc/huZPhCyOKGjCEAfD+AF0E=
MIME-Version: 1.0
In-Reply-To: <1237537967.5100.135.camel@johannes.local>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <1237143683.24621.7.camel@johannes.local>
	 <20090315202603.GA9077@elte.hu>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <1237317742.31814.28.camel@johannes.local>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
	 <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com>
	 <1237455534.5100.56.camel@johannes.local>
	 <b6a2187b0903192155q33510b57l9d5927538a0f4f99@mail.gmail.com>
	 <1237537967.5100.135.camel@johannes.local>
Date: Fri, 20 Mar 2009 18:04:29 +0800
Message-ID: <b6a2187b0903200304l469e3eeet87c51b1cddb43ea8@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 4:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> 1) It can't be before iwconfig which will result in "SET failed on
> device wlan0 ; Device or resource busy".
>  So your point 1) confuses me. Can you
> explain that a little more?

This is what happened ...

# modprobe -r iwlagn
# modprobe iwlagn
# ifconfig wlan0 up
# iwconfig wlan0 mode Managed
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Device or resource busy.


> As for 2), that is very very strange since ap auto channel auto is the
> default, so saying that before you do anything else should do anything
> at all.
>
> I suspect something is going on in the driver because the ifconfig order
> matters and for mac80211, it shouldn't make a difference when the state
> machine is really started. I'll probably need to try to reproduce this,
> but to be honest between the varying failure modes, undefined wireless
> extensions semantics, etc. I'm not very confident I can.

I'll try all the different combination again for 2.6.28, and see if
it's the same, and on the other AP that seems harder to associate (but
works well in 2.6.28, and other OSs include Nokia phones ... so I
don't think it's the AP problem ... because it's been around a while
and gone thru many 2.6.xx).

It worked so well before that I didn't even bother to think twice, and
I may have made silly mistakes along the way, so pardon me if I
confused you.

Thanks for your help.

Jeff.
