Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZCQR15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZCQR15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZCQR1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:27:48 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:48673 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZCQR1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ht7I8TQtbZU1ewGR4bQinqzge36BQWAZFWMfwpBH2orqG6lIOnTQ0m4FSrDBTwn/Nr
         gXpbyPL/QU8LWC5a6C/smvKP9JNj1SFRfEEtyqKKJ7D5zQ/tVvmDYYgn031T7ns46hHg
         VzJ2y1bUa/cIqzblJQmhbREW0+VHSZctIHv68=
MIME-Version: 1.0
In-Reply-To: <20090317171047.GF6737@tuxdriver.com>
References: <1237143683.24621.7.camel@johannes.local>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain>
	 <b6a2187b0903161655q15437156qc926c8db37d8ba4b@mail.gmail.com>
	 <20090317144802.GF3549@tuxdriver.com>
	 <20090317152801.GA6737@tuxdriver.com> <20090317153924.GA21061@elte.hu>
	 <20090317160527.GB6737@tuxdriver.com>
	 <b6a2187b0903170924u72723220x4c0a717e3cfebf8d@mail.gmail.com>
	 <20090317171047.GF6737@tuxdriver.com>
Date: Wed, 18 Mar 2009 01:27:41 +0800
Message-ID: <b6a2187b0903171027w328f1dfds781910c0571b2424@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 1:10 AM, John W. Linville
> Works for me...I even re-downloaded the patch from bugzilla.
> commit 18439c39e826191c0ef08c3a3271ce7ece46a860
> Merge: 9e8912e... b35f8ca...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Mar 17 08:59:33 2009 -0700

Same.

> [linville-t400.local]:> patch -p1 < revert-remove-ssid-knowledge-from-driver-series.patch
> patching file drivers/net/wireless/adm8211.c
> patching file drivers/net/wireless/adm8211.h
> patching file drivers/net/wireless/b43/main.c
> patching file drivers/net/wireless/b43legacy/main.c
> patching file drivers/net/wireless/iwlwifi/iwl-3945.h
> patching file drivers/net/wireless/iwlwifi/iwl-agn.c
> patching file drivers/net/wireless/iwlwifi/iwl-dev.h
> patching file drivers/net/wireless/iwlwifi/iwl-scan.c
> patching file drivers/net/wireless/iwlwifi/iwl3945-base.c
> patching file include/net/mac80211.h
> patching file net/mac80211/ieee80211_i.h
> patching file net/mac80211/main.c
> patching file net/mac80211/mlme.c
> patching file net/mac80211/wext.c
>
> Perhaps you have a dirty tree?
>        git checkout -f

May be. Checking now.

> Does that help?

Definitely. Even with the failing chunks, and I copied back the old
wext.c from 2.6.28-rc3, and now my wireless is associating to the
hidden AP on 2.6.29-rc8. I tried just a few times, and it's ok so far.
I'll have to pit against the WAG200G that seems to have a worse
behavior tomorrow. ... anyway, this is all good. With the patch, it's
_impossible_ to "auto" associate to the AP.  Definitely on the right
track!

Thanks,
Jeff.
