Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYH2P4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYH2P4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYH2P4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:56:37 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:38495
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417AbYH2P4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:56:37 -0400
X-Trace: 75969337/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQFAJG4t0jDlSwG/2dsb2JhbACBZbcJgWo
X-IronPort-AV: E=Sophos;i="4.32,293,1217804400"; 
   d="scan'208";a="75969337"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: cpu time oddity (was Re: Linux 2.6.27-rc5)
Date: Fri, 29 Aug 2008 16:56:30 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc4-bisect-damocles; KDE/4.1.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808291642.42255.alistair@devzero.co.uk>
In-Reply-To: <200808291642.42255.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291656.30639.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008 16:42:42 Alistair John Strachan wrote:
> On Friday 29 August 2008 00:26:45 Linus Torvalds wrote:
> > Another week (my weeks do seem to be eight days, don't they? Very odd),
> > another -rc.
>
> (Don't know who's responsible for this one, so I've just added Ragael to
> CC)
>
> I only noticed this recently but it's probably been happening for a while
> (doesn't seem to happen on 2.6.26):
>
> ps aux
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root         2 83033595  0.0  0     0 ?        S<   10:30 21114574:23
> [kthreadd] root      1740 83078470  0.0  0     0 ?        S<   10:31
> 21114574:23 [md0_raid1]
>
> Seems to happen only to kernel threads and at random. Last time I booted
> it was two XFS threads.
>
> Before I start another bisection, does anybody have any ideas?

Okay this is a duplicate report of:

http://bugzilla.kernel.org/show_bug.cgi?id=11209

Which seems to have stalled..

-- 
Cheers,
Alistair.
