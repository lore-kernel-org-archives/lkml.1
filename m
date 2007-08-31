Return-Path: <linux-kernel-owner+w=401wt.eu-S965217AbXHaMFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217AbXHaMFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 08:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964879AbXHaMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 08:05:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXHaMFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 08:05:25 -0400
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070830123609.GA5140@tuxdriver.com>
References: <2713029743177393055@pripojeni.net>
	 <280951420471148977@pripojeni.net> <20070828171330.GD29343@infradead.org>
	 <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
	 <20070830123609.GA5140@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 07:58:51 -0400
Message-Id: <1188561531.2668.7.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 08:36 -0400, John W. Linville wrote:
> On Thu, Aug 30, 2007 at 04:38:09AM +0300, Nick Kossifidis wrote:
> > 2007/8/28, Christoph Hellwig <hch@infradead.org>:
> 
> > > Also this whole patch seems rather pointless.  It saves only
> > > very little and turns the driver into a complete ifdef maze.
> 
> > Also most
> > people will use 5212 code only, 5211 cards are on some old laptops and
> > 5210, well i couldn't even find  a 5210 for actual testing :P
> 
> FWIW, I'd bet dollars to donuts that distros will enable them all
> together.

I would certainly _hope_ that distros enable everything -that is in the
kernel- that they can get their hands on, otherwise when you stick a
card in, it doesn't just work.

Dan

> Is saving code space the only reason to turn these off?  How much
> space do you save?
> 
> Is there some way you can isolate and/or limit the number of ifdef
> blocks further?  If so, we might consider a version of this patch
> that depends on EMBEDDED or somesuch...?
> 
> John

