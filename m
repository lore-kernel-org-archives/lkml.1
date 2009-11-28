Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZK1WTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZK1WTt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 17:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZK1WTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 17:19:48 -0500
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:43610 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751726AbZK1WTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 17:19:48 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 17:19:48 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gscKSy6vKcCA0M0z+awN5mLthsN36kcHg4/AXiDcQh9oEhDUrz2j/d9r1JgsYqoURG0sC1z0zpNdmgROYmhgs7V2i1st5je9jqS9DWikgYHMpvp0UGJRc6L6GJXsw/anePZJFMEWBtWFA94iVeiniuVbcuZNwdRzVTtPjW7CDJw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: iwOodjcVM1mJvxIGzu4N_r50DJx414rpsz7aiQ6e1mUY5kN4mmhRp22n1KJcdlJpo6l6FuG52nm6xm7yTe.S735bAgzft.9t1cuIQX.ornLmM.hY4pNcQG2cRQURNfdNOZI_3iZPSWDsYZBEEptZCz6lC6EAD9CRr8Yk6eASsUXTsJsipIZzBT_GcBZAt9wk.o3A3Wi7PVxY_5ElnODLQfwZiB3V7l313zF.97KbeLHmSX9ga7e751WGK_9IiM3m
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered with setup_irq
Date: Sat, 28 Nov 2009 14:13:13 -0800
User-Agent: KMail/1.9.10
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-arm-kernel@lists.infradead.org
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911281413.14142.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 November 2009, Thomas Gleixner wrote:
> What about analysing the code and verifying that the setup order is
> correct ?

Better to not care too much about setup order.  Sometimes it's
unavoidable -- X initializes before Y "or else..." -- but the
patch I saw was just reporting goofage better.


> Adding save/restore_irq just because you have no clue what the code
> does is utter nonsense.

Absolutely.  If that helps, find and fix the real bug.




