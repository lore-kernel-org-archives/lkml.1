Return-Path: <linux-kernel-owner+w=401wt.eu-S1764700AbXHPVSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764700AbXHPVSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbXHPVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:17:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbXHPVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:17:52 -0400
Date: Thu, 16 Aug 2007 14:17:51 -0700 (PDT)
Message-Id: <20070816.141751.115907875.davem@davemloft.net>
To: tom@opengridcomputing.com
Cc: jeff@garzik.org, swise@opengridcomputing.com, mshefty@ichips.intel.com,
       rdreier@cisco.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1187271791.4685.9.camel@trinity.ogc.int>
References: <46C310E1.7020503@opengridcomputing.com>
	<46C3B5EF.5060409@garzik.org>
	<1187271791.4685.9.camel@trinity.ogc.int>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Tucker <tom@opengridcomputing.com>
Date: Thu, 16 Aug 2007 08:43:11 -0500

> Isn't RDMA _part_ of the "software net stack" within Linux?

It very much is not so.

When using RDMA you lose the capability to do packet shaping,
classification, and all the other wonderful networking facilities
you've grown to love and use over the years.

I'm glad this is a surprise to you, because it illustrates the
point some of us keep trying to make about technologies like
this.

Imagine if you didn't know any of this, you purchase and begin to
deploy a huge piece of RDMA infrastructure, you then get the mandate
from IT that you need to add firewalling on the RDMA connections at
the host level, and "oh shit" you can't?

This is why none of us core networking developers like RDMA at all.
It's totally not integrated with the rest of the Linux stack and on
top of that it even gets in the way.  It's an abberation, an eye sore,
and a constant source of consternation.
