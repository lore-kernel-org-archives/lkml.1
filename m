Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYHOMt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYHOMt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYHOMtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:49:18 -0400
Received: from web82101.mail.mud.yahoo.com ([209.191.84.214]:27752 "HELO
	web82101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753106AbYHOMtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:49:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=maBx7kZYOAmDTo9MbP3XTio3KqfQCwE3Wv8Dlik1QBDAAL0QtzwFw7pmnxBsdCXLyC8P5X+bn9iX4x2tQp6VRZdKp/WxYD119E1R+9il3ql1W9xOhaoTSqr1y1D7mjJIulth7DX97N5lIFNygipeUwXUxIdKZyKUEN/K04DI+T8=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 15 Aug 2008 05:49:17 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- question about NMI watchdog
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <445817.22956.qm@web82101.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > I found something very interesting about the commit that first causes 
> > the lockup (3def3d6d...), and the very next commit (1e934dda...) -- if 
> > I checkout 1e94... and try to revert the changes made in 3def..., the 
> > kernel freezes in spite of the revert.
> > 
> > Because of this, I would conclude that your patch for 2.6.27-rc3 was 
> > doomed before you began, and we should look more carefully at the 
> > commits from February instead of trying to revert at the 2.6.27 HEAD.
> 
> i'm still wondering whether we could try to figure out something about 
> the nature of the hard lockup itself.
> 
> Have you tried to activate the NMI watchdog? It _usually_ works fine if 
> you use a boot option along the lines of:
> 
>    "lapic nmi_watchdog=2 idle=poll"

I have to go to work for a few hours right now, but will try this out when
I get home.  (Actually, I'm late for work as I type this... but I have my
priorities straight!  ;)

Quick question:  a quick browse of 'Documentation/nmi_watchdog.txt' suggests
that I should use "nmi_watchdog=1", since I have SMP (CPU = Athlon 64 X2,
with CONFIG_SMP=y).  Should I follow your suggestion later, or follow the
recommendation of the 'nmi_watchdog.txt' doc?


Much thanks,
Dave W.
