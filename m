Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYHWQoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYHWQoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 12:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYHWQoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 12:44:19 -0400
Received: from web82107.mail.mud.yahoo.com ([209.191.84.220]:36860 "HELO
	web82107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751380AbYHWQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 12:44:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=APh9dz7YA6S2jD+AGiiaS3PH3/afWys6U6ZJyJhfVD2qwcczqUR+mzOMeJa2QnN3QSNEm5CpR1QPGXTXTzqV5qHe5EnpiADpB4DKQnt6WfMgqRPU4JLRSNhIF8lrVqW9F3e7HZi0bZDqXcvZ6pwmsjAtT2B1ILpdThPbHqbVU68=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Sat, 23 Aug 2008 09:44:17 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <479693.91510.qm@web82107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> sorry about that, my first patch was more broken than i thought (it will 
> basically hang on _any_ box), please try the second patch.

No complaints here.  When I made myself and my machines available to help
with this regression, that included the possibility of errors.

I just send a message with the output of 'dmesg | grep ^ignoring', along
with the full 'dmesg' output gzipped.  My crummy ISP webmail interface
may have choked on it, so if you don't get that output before you see
this, then let me know so I can resend it.  (It's over 100K, though --
should I reduce the CC line first, if I have to resend?)


> Note how the above hack code does a stupid goto, and 'p' is updated for 
> the next loop iteration already. The second version of the debug patch 
> only updates 'p' in the 'continue' case and will hopefully get you much 
> further into bootup!

*sniff*
*wiping tears*

I don't care if you DO make mistakes... I LOVE you guys, man!

If you folks can fix this, then I owe anybody involved a cube of their 
favorite beer!  I'm not a beer drinker myself....  I'll just have green
tea.  ;)


Thanks,
Dave W.
