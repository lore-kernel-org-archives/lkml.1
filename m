Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXI0TPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXI0TPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXI0TPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:15:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756693AbXI0TPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:15:23 -0400
Date: Thu, 27 Sep 2007 12:15:22 -0700 (PDT)
Message-Id: <20070927.121522.52884745.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: shemminger@linux-foundation.org, helge.hafting@aitel.hist.no,
       olecom@flower.upol.cz, jbeulich@novell.com,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting?
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0709271654270.30621@fbirervta.pbzchgretzou.qr>
References: <46FB99EF.4020806@aitel.hist.no>
	<20070927075102.4335a263@freepuppy.rosehill>
	<Pine.LNX.4.64.0709271654270.30621@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Thu, 27 Sep 2007 16:55:36 +0200 (CEST)

> 
> On Sep 27 2007 07:51, Stephen Hemminger wrote:
> >
> >You need every socket to close and all routes to go away including the 
> >routes through loopback device, and still there probably are control 
> >sockets buried inside ipv6 that hold ref count.
> >
> >IMHO the kernel should just admit that IPV6 can't be removed.
> 
> I cannot accept that. If ipv6.ko has a way to tack ipv6 structs onto all 
> sockets, interfaces and addresses, it should also be able to untack it 
> again.

Then you do the work and see how incredibly difficult the
implementation is, others have tried.  It's not trivial
and at best it's a very time consuming piece of work to
embark on.

Until then it's un-removable, plain as that :-)

I don't know why we're wasting our fingers discussing this
at all to be honest with you.
