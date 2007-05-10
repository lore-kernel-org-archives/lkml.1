Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbXEJLB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbXEJLB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXEJLBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:01:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38384
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756823AbXEJLBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:01:50 -0400
Date: Thu, 10 May 2007 04:01:52 -0700 (PDT)
Message-Id: <20070510.040152.39159048.davem@davemloft.net>
To: giometti@enneenne.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510105837.GB979@enneenne.com>
References: <20070502193314.GA23367@enneenne.com>
	<20070510002740.c4350813.akpm@linux-foundation.org>
	<20070510105837.GB979@enneenne.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodolfo Giometti <giometti@enneenne.com>
Date: Thu, 10 May 2007 12:58:37 +0200

> On Thu, May 10, 2007 at 12:27:40AM -0700, Andrew Morton wrote:
> > 
> >   Please check with Dave Miller that this:
> > 
> > 	#define NETLINK_PPSAPI          20
> > 
> >   reservation is OK.
> 
> Hello, as you can see here Andrew Morton asked to me to check with you
> about NETLINK_PPSAPI reservation.
> 
> Please, let me know if it's ok.

It's not OK, please use the generic netlink interface and as
such you will not need to allocate any numbers at all.

Documentation/networking/generic_netlink.txt gives a link
to some infomration on this topic.
