Return-Path: <linux-kernel-owner+w=401wt.eu-S1760633AbXEJLvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633AbXEJLvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXEJLvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:51:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45662
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754805AbXEJLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:51:38 -0400
Date: Thu, 10 May 2007 04:51:40 -0700 (PDT)
Message-Id: <20070510.045140.31639853.davem@davemloft.net>
To: giometti@enneenne.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510114502.GJ11009@enneenne.com>
References: <20070510105837.GB979@enneenne.com>
	<20070510.040152.39159048.davem@davemloft.net>
	<20070510114502.GJ11009@enneenne.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodolfo Giometti <giometti@enneenne.com>
Date: Thu, 10 May 2007 13:45:03 +0200

> On Thu, May 10, 2007 at 04:01:52AM -0700, David Miller wrote:
> > 
> > It's not OK, please use the generic netlink interface and as
> > such you will not need to allocate any numbers at all.
> > 
> > Documentation/networking/generic_netlink.txt gives a link
> > to some infomration on this topic.
> 
> If I well understand doing like this means that I have to modify also
> userland API, is that true?

Yes.

> I know that you are forcing in using this new interface for new kernel
> projects, but if I have to change my code I need also change NTPD
> related code and this is frustrating. I have to interact with both
> kernel developers and NTPD ones... :)
>
> It could be acceptable let me use id "20" (or just another number) to
> allow Andrew Morton and other LinuxPPS users to test this new support?
> Please, consider that this is not a new project, it was developed
> since 2005 when this new interface was not available.

Being a 2005 project means only that you've been out of tree for
nearly 2 years.

Sorry, we are not allocating a netlink IDs for folks, and we're doing
it exactly because generic netlink avoids all the fixed numbering API
issues.
