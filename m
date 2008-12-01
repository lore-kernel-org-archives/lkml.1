Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYLAPde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYLAPde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYLAPd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:33:26 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:40373 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYLAPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PnDQKQU41ixoCZMDZDuytB0zw9jKKNMQt/nvsFzIi7bblEKIU7My0E0QYYqR7Z9SUC
         thLdXWANfh7aCf7p3Kmh7+8IaNHrh/YJnCVsDJbOD2a6Zb1rl+s4ilI49vqjMf2M+Zo1
         xcq2EHPhIpBIsbNbvsnmPE6M5bTXXVr1cBfFM=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 17:33:15 +0200
Message-Id: <1228145595.16647.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 00:12 +0200, Nick Kossifidis wrote:
> 2008/11/10 Maxim Levitsky <maximlevitsky@gmail.com>:
> > Bob Copeland wrote:
> >> On Fri, Nov 7, 2008 at 10:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by
> >>> default in ubuntu...
> >>> wireless more or less works, but kernel log is full of backtraces.
> >>
> >> As you've seen, these should at least be gone now...
> >>
> >>> Was able to connect to my WPA2 access point.
> >>> Sometimes wireless fails completely, especially after suspend to ram.
> >>
> >> Did you get noise calibration failures in dmesg at this point?  Felix posted
> >> a patch recently that handles them better.
> > Yep, but they seems to be gone in latest -git too.
> > Wireless work fine now, it seems like my iwl3945.
> >
> >>
> >>> Advanced features like monitor/injection work, but when I changed the card's
> >>> mac address it stopped working.
> >>> I also noticed that if I then start airodump, then wireless works with new
> >>> mac.
> > Why it doesn't accept new mac?, can this be fixed?
> >
> >
> >>
> >>> ** 4 - wireless led doesn't work.
> >>> ath5k devs, can you fix this?
> >>
> >> Currently all the LED code we have in there is for setting a particular gpio
> >> for particular laptops (and they differ between models).  We only have quirks
> >> for IBM and HP, none for Acer.  Also, the legacy-hal seems to have a different
> >> strategy for 2425 chips.  I can try to hack up some code for you to test.
> >>
> >
> > I have seen on the web that madwifi did support the led with some gpio settings
> >
> > sysctl -w dev.wifi0.ledpin=3
> > sysctl -w dev.wifi0.softled=1
> >
> > from https://help.ubuntu.com/community/AspireOne
> >
> > Best regards,
> >        Maxim Levitsky
> 
> i think that some led settings are stored on EEPROM, let me check it out...
Hi,
Any update on that?

Best regards,
	Maxim Levitsky


> 
> 

