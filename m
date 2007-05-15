Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbXEOA4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbXEOA4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 20:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXEOA4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 20:56:16 -0400
Received: from web36708.mail.mud.yahoo.com ([209.191.85.42]:24253 "HELO
	web36708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753999AbXEOA4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 20:56:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=s51HBD/JsCbVJTLrb/ud6/XLLQ/uESl0Iin45kuEAygyu90hhhW4JfYZTHbijhcHGpUtP0Uko97cD0WyS0dLXHavaGaMUCy5k0CSAZhhBwLuKCIo784D53TBHaNIkNUpRsyaURPmqkax9K2xq2LLrliM2qx+qAoL2tqcv6AKYRw=;
X-YMail-OSG: TG0HyRwVM1mrjVRN97uBLpPbH9h35YBSU0XvsAAsxEX9jXv7JSyd_EBuWki_6Elztrkng9cbcRDmJ6G75wpuS_8xsvVpqQatRfdU.tV8JYqC3UbVHFwegOf22dPq3A--
Date: Mon, 14 May 2007 17:56:15 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
To: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pierre Ossman <drzeus@drzeus.cx>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20070514214833.GA249@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <390169.9239.qm@web36708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > > 	- Do we need freezeable workqueues ?
> > 
> > Well, we have at least one case in which they appear to be useful.
> 

I need freezeable wq exactly for the fact that they are synchronized with suspend/resume. My
workitem may do device_register/unregister and it can (and will be) scheduled from irq handler
during resume. As far as I understand, before freezeable wqs, kthreads were the only way to
achieve this behavior, which is less convenient.




 
____________________________________________________________________________________
Need Mail bonding?
Go to the Yahoo! Mail Q&A for great tips from Yahoo! Answers users.
http://answers.yahoo.com/dir/?link=list&sid=396546091
