Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbXF0HyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbXF0HyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXF0Hx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:53:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33293
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbXF0Hx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:53:57 -0400
Date: Wed, 27 Jun 2007 00:54:16 -0700 (PDT)
Message-Id: <20070627.005416.43852201.davem@davemloft.net>
To: dan.j.williams@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       christopher.leech@intel.com
Subject: Re: [RFC PATCH 0/2] dmaengine: preparation for raid acceleration
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070602001527.1707.58092.stgit@dwillia2-linux.ch.intel.com>
References: <20070602001527.1707.58092.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Jun 2007 17:17:49 -0700

> Hello David,
> 
> The following two patches are part of the raid acceleration series I
> would like to push for 2.6.23 consideration.  I am sending these two
> separately for your review for the following reasons: the 'dmaengine'
> core initially came in through netdev,  patch #2 makes changes to
> net/dev/core.c, and lastly I have an ack on the raid changes but no ack
> from the community on the i/oat and dmaengine changes.
> 
>       dmaengine: add base support for the async_tx api
>       dmaengine: move channel management to the client

Dan, you can merge this through Andrew's -mm tree and this
will actually make things easier for me.  The net changes
are minimal and I have no problem with them.

Acked-by: David S. Miller <davem@davemloft.net>
