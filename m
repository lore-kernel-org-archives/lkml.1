Return-Path: <linux-kernel-owner+w=401wt.eu-S965288AbXHaNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288AbXHaNbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965033AbXHaNbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:31:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60062 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964957AbXHaNbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:31:01 -0400
Message-ID: <46D8180A.5070902@garzik.org>
Date: Fri, 31 Aug 2007 09:30:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
References: <2713029743177393055@pripojeni.net>	 <280951420471148977@pripojeni.net> <20070828171330.GD29343@infradead.org>	 <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>	 <20070830123609.GA5140@tuxdriver.com> <1188561531.2668.7.camel@xo-3E-67-34.localdomain>
In-Reply-To: <1188561531.2668.7.camel@xo-3E-67-34.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Thu, 2007-08-30 at 08:36 -0400, John W. Linville wrote:
>> On Thu, Aug 30, 2007 at 04:38:09AM +0300, Nick Kossifidis wrote:
>>> 2007/8/28, Christoph Hellwig <hch@infradead.org>:
>>>> Also this whole patch seems rather pointless.  It saves only
>>>> very little and turns the driver into a complete ifdef maze.
>>> Also most
>>> people will use 5212 code only, 5211 cards are on some old laptops and
>>> 5210, well i couldn't even find  a 5210 for actual testing :P
>> FWIW, I'd bet dollars to donuts that distros will enable them all
>> together.
> 
> I would certainly _hope_ that distros enable everything -that is in the
> kernel- that they can get their hands on, otherwise when you stick a
> card in, it doesn't just work.

Distros definitely -do not- do this.  Plenty of ancient ISA drivers are 
disabled at build time, for example, in many distros.

	Jeff



