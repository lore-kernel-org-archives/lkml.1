Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYDLHGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYDLHGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 03:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYDLHF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 03:05:59 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:11534 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbYDLHF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:05:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkBAMP7/0fEAmHGfGdsb2JhbACRUwEBEA4YmEs
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
Date: Sat, 12 Apr 2008 09:05:50 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
References: <200804112241.44626.bonganilinux@mweb.co.za> <20080411214257.GA4979@martell.zuzino.mipt.ru>
In-Reply-To: <20080411214257.GA4979@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804120905.50745.bonganilinux@mweb.co.za>
X-Original-Subject: Re: Shutdown and Reboot Regression 2.6.25-rc[78]
X-Spam-Score: 0.1 (/)
X-Spam-Score-Int: 1
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-03.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  On Friday 11 April 2008 23:42:57 Alexey Dobriyan wrote: >
	On Fri, Apr 11, 2008 at 10:41:44PM +0200, Bongani Hlope wrote: > > I found
	a regression in version 2.6.25-rc7, which causes my computer not > > to shutdown
	or reboot. I get a complete lock up (no keyboard and Sys-Rq) > > just before
	it normally shuts down the alsa service. > > > > I did a git bisect and it
	points to this reversion: > > [266c2e0abeca649fa6667a1a427ad1da507c6375]
	Make printk() console > > semaphore accesses sensible > > Is it 100% reproducable?
	I mean sometimes I also have complete lockup right > after one of eth interfaces
	shutdown during shutdown sequence. And it's > also recent. > > But it triggers
	~1 time in 10 subjectively.. [...] 
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
X-Scan-Signature: f4f3b324620defc3711de59df1ad39f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2008 23:42:57 Alexey Dobriyan wrote:
> On Fri, Apr 11, 2008 at 10:41:44PM +0200, Bongani Hlope wrote:
> > I found a regression in version 2.6.25-rc7, which causes my computer not
> > to shutdown or reboot. I get a complete lock up (no keyboard and Sys-Rq)
> > just before it normally shuts down the alsa service.
> >
> > I did a git bisect and it points to this reversion:
> > [266c2e0abeca649fa6667a1a427ad1da507c6375] Make printk() console
> > semaphore accesses sensible
>
> Is it 100% reproducable? I mean sometimes I also have complete lockup right
> after one of eth interfaces shutdown during shutdown sequence. And it's
> also recent.
>
> But it triggers ~1 time in 10 subjectively..

it is 100% reproducible with rc7 and rc8, I haven't come across the bug with 
rc9 though..


