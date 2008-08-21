Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYHUNdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYHUNdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYHUNdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:33:10 -0400
Received: from web82108.mail.mud.yahoo.com ([209.191.84.221]:43577 "HELO
	web82108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753884AbYHUNdI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:33:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Yn0IYOVZkNISKBLTSq70XHhqZrLO83DKGR7xjUKSKCNXiRLCks9HQjoYKo8hxVmQ2rkL2LMQRp3wddAdVGXvsS112Cx0riwahW3gSnTHANPB2bI/ouvylf0DOGT/TJ68VEVv9UtAacBJ8NnO34ZwT/+SCHyfhJki7FWm69eURRw=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Thu, 21 Aug 2008 06:33:06 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Vivek Goyal <vgoyal@redhat.com>, Bill Fink <billfink@mindspring.com>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <32413.7552.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Please advise me on how you would like me to handle 2.6.27 kernels.
> > If I use your patch on 2.6.27-rc3, the message scroll off the 80x25 
> > screen before I can see them... 
> 
> Couldn't you play with CONFIG_BOOT_PRINTK_DELAY?

Thanks for this!  I am not a developer, so I am not familiar with all
of the little tweaks available in the kernel configs -- I've probably
seen this dozens of times, but ignored it because I wasn't debugging.

Now that I _am_ debugging, I wish I had paid more attention.

When I tried it, my kernel hung much earlier in the boot process.  The
help text for CONFIG_BOOT_PRINTK_DELAY even mentions that this can be
a problems on SMP systems, and that is exactly what I have.

Bummer.


Thanks though,
Dave W.
