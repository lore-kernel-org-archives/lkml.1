Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbXF2TE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbXF2TE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbXF2TEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:04:50 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:45250 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751558AbXF2TEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:04:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=JD/gD6HoOACoUmNARCTzo5pOzmAJzzZvwX45h3ZUTbEOILitPa2IEdQaPm8aTSiYjd5QyKEUb2J/8cwWQmpFfZBa4O7dQNHGWQiDbaoGRCYUteuvTckRtj2cZyHRsZcTT1YIXBDomoct72bJcVsdWXaKFJ6ECelacbxpSybRZUI=;
Date: Fri, 29 Jun 2007 23:04:05 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629190404.GA4064@ms2.inr.ac.ru>
References: <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com> <20070629142617.GA341@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629142617.GA341@tv-sign.ru>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Also, create_workqueue() is very costly. The last 2 lines should be
> reverted.

Indeed.

The result improves from 3988 nanoseconds to 3975. :-)
Actually, the difference is within statistical variance,
which is about 20 ns.

Alexey
