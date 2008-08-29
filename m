Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYH2Pmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYH2Pmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYH2Pmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:42:46 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:36166
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYH2Pmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:42:45 -0400
X-Trace: 20363021/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAKy1t0jDlSwG/2dsb2JhbACBZbZogWo
X-IronPort-AV: E=Sophos;i="4.32,293,1217804400"; 
   d="scan'208";a="20363021"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: cpu time oddity (was Re: Linux 2.6.27-rc5)
Date: Fri, 29 Aug 2008 16:42:42 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc4-bisect-damocles; KDE/4.1.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291642.42255.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008 00:26:45 Linus Torvalds wrote:
> Another week (my weeks do seem to be eight days, don't they? Very odd),
> another -rc.

(Don't know who's responsible for this one, so I've just added Ragael to CC)

I only noticed this recently but it's probably been happening for a while
(doesn't seem to happen on 2.6.26):

ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         2 83033595  0.0  0     0 ?        S<   10:30 21114574:23 [kthreadd]
root      1740 83078470  0.0  0     0 ?        S<   10:31 21114574:23 [md0_raid1]

Seems to happen only to kernel threads and at random. Last time I booted
it was two XFS threads.

Before I start another bisection, does anybody have any ideas?

-- 
Cheers,
Alistair.
