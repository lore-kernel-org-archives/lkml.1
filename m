Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYG2LZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYG2LZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYG2LZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:25:05 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:28402
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444AbYG2LZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:25:04 -0400
X-Trace: 116651546/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAOyajkjDlSwG/2dsb2JhbACBW4lFpUw
X-IronPort-AV: E=Sophos;i="4.31,272,1215385200"; 
   d="scan'208";a="116651546"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Date: Tue, 29 Jul 2008 12:25:00 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291049.47342.alistair@devzero.co.uk> <1217326195.10489.10.camel@johannes.berg>
In-Reply-To: <1217326195.10489.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291225.00679.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 11:09:55 Johannes Berg wrote:
> > However, on 2.6.27-rc1 I see the following instead:
> >
> > [   12.120189] firmware: requesting zd1211/zd1211b_ub
> > [   12.166388] firmware: requesting zd1211/zd1211b_uphr
> > [   12.218877] zd1211rw 4-2:1.0: firmware version 4725
> > [   12.258877] zd1211rw 4-2:1.0: zd1211b chip 050d:705c v4810 high
> > 00-17-3f AL2230_RF pa0 g--NS [   13.097289] wlan0: authenticate with AP
> > 00:17:3f:a4:d6:9d
> > [   13.296890] wlan0: authenticate with AP 00:17:3f:a4:d6:9d
> > [   13.496890] wlan0: authenticate with AP 00:17:3f:a4:d6:9d
> > [   13.696886] wlan0: authentication with AP 00:17:3f:a4:d6:9d timed out
> >
> > And Debian's networking script fails to obtain an IP address. I notice
> > the line:
> >
> > [   18.613540] wlan0: Initial auth_alg=0
> >
> > Is missing from the 2.6.27-rc1 dmesg, however my config should not have
> > been altered (I simply make oldconfig'ed it). Find attached anyway.
> >
> > I'll start a bisection if nobody has any immediate ideas.
>
> This is about the 100 millionth time this is reported. Please try the
> patch I just posted.

If it doesn't strain you too much more, could you actually tell me where this 
is? Your last 5 posts to LKML don't seem to contain such a patch, and I'm not 
subscribed to linux-wireless.

-- 
Cheers,
Alistair.
