Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYDJHrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYDJHrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYDJHri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:47:38 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:56264
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbYDJHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:47:37 -0400
X-Trace: 55861358/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkoFAA5j/UdTQwss/2dsb2JhbACBXakU
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: linux-ide@vger.kernel.org
Subject: Re: Western Digital GreenPower drives and Linux
Date: Thu, 10 Apr 2008 08:48:08 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200804092118.35501.tvrtko@ursulin.net>
In-Reply-To: <200804092118.35501.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804100848.08442.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2008 21:18:35 Tvrtko A. Ursulin wrote:
> I got one of them (WD5000AACS) recently and to my horror after less than
> three days of being power on this is what I saw:
>
> 9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
> 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
>
> At this rate the disk would reach it's design limit for load/unload cycles
> in around 80 days. Not good - so I implemented a lame workaround of keeping
> disk busy every couple of seconds - hopefully that won't kill it sooner
> that unloads would..
>
> I am also currently talking with first line of WD's tech support trying to
> get some data on how exactly those drives manage head unloading, but that
> may not lead anywhere useful.

I got back from WD's tech support and received a DOS utility which can control 
this drive feature, apparently using vendor specific commands. With it head 
unload timer can be disabled or set to a period between 100ms and 25.5s. 

Of course I asked for more than a DOS utility, but the question really is how 
was this feature intended to work with Windows for example, is there 
something there which would prevent such rapid load/unload cycle growth, and 
why isn't it documented somewhere?

I am kind off hoping that someone from WD is reading this list and will notice 
this in case my effort with tech support fails.

Tvrtko
