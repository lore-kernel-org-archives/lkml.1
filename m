Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYJVSA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYJVSA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYJVSAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:00:45 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:50449 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872AbYJVSAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:00:44 -0400
Date: Wed, 22 Oct 2008 11:00:12 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Jouni Malinen <j@w1.fi>,
       Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
Message-ID: <20081022180012.GA6089@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <48FDFCCA.8040604@lwfinger.net> <20081022072840.GD16005@jm.kir.nu> <48FF5933.3080501@lwfinger.net> <1224695189.30459.6.camel@johannes.berg> <20081022173721.GA5786@bougret.hpl.hp.com> <1224697587.30459.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224697587.30459.37.camel@johannes.berg>
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jt@hpl.hp.com
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jean Tourrilhes <jt@hpl.hp.com>
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jt@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 07:46:27PM +0200, Johannes Berg wrote:
> On Wed, 2008-10-22 at 10:37 -0700, Jean Tourrilhes wrote:
> 
> > 	If you want me to understand what it's about, you may want to
> > give me a bit more context.
> 
> Sorry. Basically, Larry is saying that due to a kernel change, iwlist
> will print out things like
>                     IE: Unknown: 0017465249545A21426F7820466F6E20574C414E2037313133
>                     IE: Unknown: 010482848B96
>                     IE: Unknown: 030106
>                     IE: Unknown: 2A0106
>                     IE: IEEE 802.11i/WPA2 Version 1
>                         Group Cipher : TKIP
>                         Pairwise Ciphers (1) : CCMP
>                         Authentication Suites (1) : PSK
>                     IE: Unknown: 32080C1218243048606C
>                     IE: WPA Version 1
>                         Group Cipher : TKIP
>                         Pairwise Ciphers (1) : TKIP
>                         Authentication Suites (1) : PSK
>                     IE: Unknown: DD0A0800280101000200FF0F
>                     IE: Unknown: DD180050F2020101800003A4000027A4000042435E0062322F00
> 
> 
> where all the IE: Unknown lines are unexpected.

	Unexpected, but not broken. That's good.

> > 	Alternatively, just send me a patch for Wireless Tools, and
> > I'll put it in the next release. Wireless Tools is still maintained
> > and I still do releases, even if I don't put much cycles into it.
> 
> The problem is that we don't quite know what to do about them :)

	We are not supposed to "do" anything, but to show the
underlying data in a user friendly way. I can't believe that we could
not parse this data properly, we manage to parse other IEs
correctly. If you are debugging a problem with wpa_supplicant, or a
Access Point issue, what would *you* want to see there.

> johannes

	Have fun...

	Jean


