Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYDKSHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYDKSHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbYDKSHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:07:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34705
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760421AbYDKSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:07:01 -0400
Date: Fri, 11 Apr 2008 11:07:02 -0700 (PDT)
Message-Id: <20080411.110702.146231359.davem@davemloft.net>
To: johnpol@2ka.mipt.ru
Cc: lkml@rtr.ca, ilpo.jarvinen@helsinki.fi, jesper.juhl@gmail.com,
       tilman@imap.cc, yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080411151821.GA32398@2ka.mipt.ru>
References: <20080411143537.GA27874@2ka.mipt.ru>
	<47FF7CED.9090601@rtr.ca>
	<20080411151821.GA32398@2ka.mipt.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Fri, 11 Apr 2008 19:18:21 +0400

> On Fri, Apr 11, 2008 at 10:59:57AM -0400, Mark Lord (lkml@rtr.ca) wrote:
> > >If you do not care about bug, why do you ever bothered filling it?
> > ..
> > 
> > Because I care, about Linux's reputation and performance.
> > I care about basic networking operations, and knew that this bug
> > would probably affect other applications once widely deployed.
> > 
> > I care about Linux.  That's why.
> 
> Blah-blah-blah, you care so much, that pissed people off which suggested
> you how to really help Linux. And then you returned with besiect
> results. You helped, but if you just cared, you had missed first part.

Every time I see someone play the "I care about Linux" card, they are
typically being a hypocrit.  It's a knee jerk, defensive gesture, and
usually has absolutely zero substance.

> > The current generation of kernel "code submitters" here
> > seems to have never learned those.  Bummer.
> 
> Next time I will ask soothsayer, she really knows how to debug network
> bug with following description: "it worked before I changed a kernel
> version. you have to return my puppets back".

Thanks for your support Evgeniy, it is truly appreciated.

We had Mark's bug fixed in 15 minutes once the bisect result was
known, even after Ilpo and myself had scanned through the changesets.

This proves the utility of bisect and in fact that trying to intuit
the cause by continuing to study changesets and code would have been a
complete waste of time.

Yes, Mark, we used to do things that way for every bug in the kernel.
And as a result many bugs sat unfixed for weeks if not months.  Many
of us have left the cave, feel free to join us.
