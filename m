Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZC2IEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZC2IEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZC2IEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:04:10 -0400
Received: from mk-outboundfilter-5-a-2.mail.uk.tiscali.com ([212.74.114.4]:12620
	"EHLO mk-outboundfilter-5-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZC2IEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:04:06 -0400
X-Trace: 144915807/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.11.44/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-MUA: KMail/1.9.10
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai0FAODHzklTQwss/2dsb2JhbACBUMdugjKBSAY
X-IronPort-AV: E=Sophos;i="4.38,441,1233532800"; 
   d="scan'208";a="144915807"
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression in 2.6.29] forcedeth doesn't work after resume from hibernation (was: Re: Resume after hibernation regression in 2.6.29)
Date: Sun, 29 Mar 2009 09:03:57 +0100
User-Agent: KMail/1.9.10
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Ayaz Abdulla <aabdulla@nvidia.com>, netdev@vger.kernel.org,
       Ed Swierk <eswierk@arastra.com>, Arthur Jones <ajones@riverbed.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
References: <200903261920.32173.tvrtko@ursulin.net> <200903271255.36429.rjw@sisk.pl> <200903272109.21259.rjw@sisk.pl>
In-Reply-To: <200903272109.21259.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903290903.57911.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009 20:09:20 Rafael J. Wysocki wrote:
> I was able to reproduce the problem and identify the commit that broke the
> resume of forcedeth, which turned out to be:
>
> commit cb52deba12f27af90a46d2f8667a64888118a888
> Author: Ed Swierk <eswierk@arastra.com>
> Date:   Mon Dec 1 12:24:43 2008 +0000
>
>     forcedeth: power down phy when interface is down
>
>     Signed-off-by: Ed Swierk <eswierk@arastra.com>
>     Tested-by: Arthur Jones <ajones@riverbed.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> Since I have no slightest idea of what this commit is supposed to achieve,
> I can only ask for reverting it.  It reverts cleanly, BTW.

Reverting this fixes it for me as well.

Thanks for your effort!

Tvrtko
